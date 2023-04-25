require "rails_helper"

RSpec.describe "/road_trip" do
  # always leave this on (it uses Time.now): 
    before do
      WebMock.allow_net_connect!
    end
    after do
      WebMock.disable_net_connect!
    end

  describe "#index" do
    before(:each) do
      ny_lat_lng = File.read("spec/fixtures/map_quest/ny_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=newyork,ny")
      .to_return(status: 200, body: ny_lat_lng, headers: {})

      la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
      .to_return(status: 200, body: la_lat_lng, headers: {})

      xyz_abc = File.read("spec/fixtures/map_quest/xyzabc_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=xyz,abc")
      .to_return(status: 200, body: xyz_abc, headers: {})

      ny_la_directions = File.read("spec/fixtures/map_quest/ny_la_directions.json")
      stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=40.71453,-74.00712&key=#{ENV["MAPQUEST_API_KEY"]}&to=34.05357,-118.24545")
      .to_return(status: 200, body: ny_la_directions, headers: {})

      la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
      stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
      .to_return(status: 200, body: la_weather_info, headers: {})
    end

    describe "happy path tests" do
      it "returns a 'road_trip' type json object" do
        hermione = User.create({ email: "HermioneSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { origin: "New York, NY", destination: "Los Angeles, CA", api_key: hermione.api_key } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(user_params)
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)
        
        expect(parsed_data).to be_a(Hash)
        expect(parsed_data.keys).to eq([:data])
        expect(parsed_data[:data]).to be_a(Hash)
        expect(parsed_data[:data].keys).to eq([:id, :type, :attributes])

        expect(parsed_data[:data][:id]).to eq(nil)
        expect(parsed_data[:data][:type]).to eq("road_trip")
        expect(parsed_data[:data][:attributes]).to be_a(Hash)
        expect(parsed_data[:data][:attributes].keys).to eq([:start_city, :end_city, :travel_time, :weather_at_eta])
        expect(parsed_data[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(parsed_data[:data][:attributes][:weather_at_eta].keys).to eq([:datetime, :temperature, :condition])
      end
    end

    describe "sad path tests" do
      let(:expected_hash) { 
        {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": "Unauthorized request."
            }]
        }
      }

      it "returns 401 - Unauthorized when api_key is incorrect" do
        hermione = User.create({ email: "HermioneSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { origin: "New York, NY", destination: "Los Angeles, CA", api_key: "lmnopqrx1234567890" } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(user_params)
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(401)
        expect(parsed_data).to eq(expected_hash)
      end

      it "returns 401 - Unauthorized when api_key is nil" do
        hermione = User.create({ email: "HermioneSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { origin: "New York, NY", destination: "Los Angeles, CA", api_key: nil } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(user_params)
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(401)
        expect(parsed_data).to eq(expected_hash)
      end

      it "returns error message 404 when one or more location names are invalid" do
        expected_hash = {
          "errors":
          [{
              "status": '404',
              "title": 'Invalid Request',
              "detail": "One or more location names are invalid."
            }]
        }
        hermione = User.create({ email: "HermioneSchoolEmail@hogwarts.com", password: "ImmaWizardtoo!", api_key: SecureRandom.hex })
        user_params = { origin: "New York, NY", destination: "xyz,abc", api_key: hermione.api_key } 

        headers = {"CONTENT_TYPE" => "application/json"}
        post "/api/v1/road_trip", headers: headers, params: JSON.generate(user_params)
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(404)
        expect(parsed_data).to eq(expected_hash)
      end
    end
  end
end