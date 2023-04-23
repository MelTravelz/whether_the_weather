require "rails_helper"

RSpec.describe WeatherService do
  describe "instance methods" do
    context "#fetch_all_weather_info" do
      it "returns json object" do
        # Los Angeles, CA coordinates = 34.05357,-118.24545
        expect(WeatherService.new.fetch_forecast("34.05357,-118.24545")).to be_a(Hash)
      end
    end
  end
end