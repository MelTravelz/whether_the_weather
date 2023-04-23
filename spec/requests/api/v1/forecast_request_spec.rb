require "rails_helper"

RSpec.describe "/api/v1/forecast" do
  describe "#index" do
    before(:each) do
      la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
      .to_return(status: 200, body: la_lat_lng, headers: {})

      la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
      stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
      .to_return(status: 200, body: la_weather_info, headers: {})
    end

    it "returns a forecast type json object" do
      get '/api/v1/forecast?location=losangeles,ca'
      
      parsed_data = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      
      expect(parsed_data).to be_a(Hash)
      expect(parsed_data[:data]).to be_a(Hash)
      expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

      expect(parsed_data[:data][:id]).to eq(nil)
      expect(parsed_data[:data][:type]).to eq("forecast")
      expect(parsed_data[:data][:attributes]).to be_a(Hash)
      expect(parsed_data[:data][:attributes].keys).to eq([:current_weather, :daily_weather, :hourly_weather])

      expect(parsed_data[:data][:attributes][:current_weather]).to be_a(Hash)
      expect(parsed_data[:data][:attributes][:current_weather].keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])
      
      expect(parsed_data[:data][:attributes][:daily_weather]).to be_an(Array)
      expect(parsed_data[:data][:attributes][:daily_weather].first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
      
      expect(parsed_data[:data][:attributes][:hourly_weather]).to be_an(Array)
      expect(parsed_data[:data][:attributes][:hourly_weather].first.keys).to eq([:time, :temperature, :conditions, :icon])
    end
  end
end