require "rails_helper"

RSpec.describe WeatherService do
  describe "instance methods" do
    context "#fetch_forecast" do
      it "returns json object" do
        la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})

        # Los Angeles, CA coordinates = 34.05357,-118.24545
        response = WeatherService.new.fetch_forecast("34.05357,-118.24545")
        keys = [:location, :current, :forecast]

        expect(response).to be_a(Hash)
        expect(response.keys).to eq(keys)
      end
    end
  end
end
