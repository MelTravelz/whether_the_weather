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
    it "returns a json object, forecast type" do
      get '/api/v1/forecast?location=losangeles,ca'
      forecast = JSON.parse(response.body, symbolize_names: true)

      expect(response).to be_successful
    end
  end
end