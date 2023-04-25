require "rails_helper"

RSpec.describe "/api/v1/forecast" do
  describe "#index" do
    describe "happy path tests" do
      before(:each) do
        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
        .to_return(status: 200, body: la_lat_lng, headers: {})

        la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})
      end

      it "returns a 'forecast' type json object" do
        get '/api/v1/forecast?location=losangeles,ca'
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        # expect(response).to be_successful
        expect(response).to have_http_status(200)

        expect(parsed_data).to be_a(Hash)
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:id]).to eq(nil)
        expect(parsed_data[:data][:type]).to eq("forecast")
        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])

        expect(parsed_data[:data][:attributes][:current_weather]).to be_a(Hash)
        expect(parsed_data[:data][:attributes][:current_weather].keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])
        expect(parsed_data[:data][:attributes][:current_weather][:last_updated]).to eq("2023-04-22 17:00")
        expect(parsed_data[:data][:attributes][:current_weather][:temperature]).to eq(79)
        expect(parsed_data[:data][:attributes][:current_weather][:feels_like]).to eq(77.4)
        expect(parsed_data[:data][:attributes][:current_weather][:humidity]).to eq(36)
        expect(parsed_data[:data][:attributes][:current_weather][:uvi]).to eq(7)
        expect(parsed_data[:data][:attributes][:current_weather][:visibility]).to eq(9)
        expect(parsed_data[:data][:attributes][:current_weather][:condition]).to eq("Sunny")
        expect(parsed_data[:data][:attributes][:current_weather][:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")

        
        expect(parsed_data[:data][:attributes][:daily_weather]).to be_an(Array)
        expect(parsed_data[:data][:attributes][:daily_weather].first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
        expect(parsed_data[:data][:attributes][:daily_weather].first[:date]).to eq("2023-04-22")
        expect(parsed_data[:data][:attributes][:daily_weather].first[:sunrise]).to eq("06:13 AM")
        expect(parsed_data[:data][:attributes][:daily_weather].first[:sunset]).to eq("07:30 PM")
        expect(parsed_data[:data][:attributes][:daily_weather].first[:max_temp]).to eq(86.7)
        expect(parsed_data[:data][:attributes][:daily_weather].first[:min_temp]).to eq(64)
        expect(parsed_data[:data][:attributes][:daily_weather].first[:condition]).to eq("Sunny")
        expect(parsed_data[:data][:attributes][:daily_weather].first[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")

        
        expect(parsed_data[:data][:attributes][:hourly_weather]).to be_an(Array)
        expect(parsed_data[:data][:attributes][:hourly_weather].first.keys).to eq([:time, :temperature, :conditions, :icon])
        expect(parsed_data[:data][:attributes][:hourly_weather].first[:time]).to eq("00:00")
        expect(parsed_data[:data][:attributes][:hourly_weather].first[:temperature]).to eq(69.8)
        expect(parsed_data[:data][:attributes][:hourly_weather].first[:conditions]).to eq("Clear")
        expect(parsed_data[:data][:attributes][:hourly_weather].first[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/night/113.png")
      end
    end

    describe "sad path tests" do
      it "returns error json object when city,state is not valid" do
        xyz_abc = File.read("spec/fixtures/map_quest/xyzabc_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=xyz,abc")
        .to_return(status: 200, body: xyz_abc, headers: {})

        get '/api/v1/forecast?location=xyz,abc'

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)

        expected_hash = 
          {
            "errors":
            [{
                "status": '404',
                "title": 'Invalid Request',
                "detail": ["Location name is invalid."]
              }]
          }

        expect(error_response).to eq(expected_hash)
      end

      it "returns error json object when city,state is not entered/empty" do
        empty = File.read("spec/fixtures/map_quest/empty_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=")
        .to_return(status: 200, body: empty, headers: {})

        get '/api/v1/forecast?location='

        expect(response).to have_http_status(404)
        error_response = JSON.parse(response.body, symbolize_names: true)

        expected_hash = 
          {
            "errors":
            [{
                "status": '404',
                "title": 'Invalid Request',
                "detail": ["Location name cannot be blank."]
              }]
          }

        expect(error_response).to eq(expected_hash)
      end
    end
  end
end