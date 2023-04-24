require "rails_helper"

RSpec.describe "/api/v1/salaries" do
  describe "#show" do
    describe "happy path tests" do
      before(:each) do
        teleport_la_salaries = File.read("spec/fixtures/teleport/la_salaries.json")
        stub_request(:get, "https://api.teleport.org/api/urban_areas/slug:los-angeles/salaries/")
        .to_return(status: 200, body: teleport_la_salaries, headers: {})

        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
        .to_return(status: 200, body: la_lat_lng, headers: {})

        la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})
      end

      it "returns a salaries type json object" do
        get '/api/v1/salaries?destination=los-angeles'
      
        parsed_data = JSON.parse(response.body, symbolize_names: true)
        # expect(response).to be_successful
        expect(response).to have_http_status(200)

      end

    end
  end

end