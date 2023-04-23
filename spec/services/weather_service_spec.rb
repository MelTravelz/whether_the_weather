require "rails_helper"

RSpec.describe WeatherService do
  describe "instance methods" do
    context "#fetch_forecast" do
      it "returns json object" do
        all_weather_info = File.read("spec/fixtures/weather/LA_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: all_weather_info, headers: {})

        # Los Angeles, CA coordinates = 34.05357,-118.24545
        expect(WeatherService.new.fetch_forecast("34.05357,-118.24545")).to be_a(Hash)
      end
    end
  end
end
