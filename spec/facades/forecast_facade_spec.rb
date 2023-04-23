require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    context "#initialize" do
      it "exists and creates an instance of mapquest & weather services" do
        forecast_facade = ForecastFacade.new

        expect(forecast_facade).to be_a(ForecastFacade)
        expect(forecast_facade.mapquest_service).to be_a(MapQuestService)
        expect(forecast_facade.weather_service).to be_a(WeatherService)
      end
    end

    context "#forecast_info" do
      before(:each) do
        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=Los%20Angeles,%20CA")
        .to_return(status: 200, body: la_lat_lng, headers: {})

        la_weather_info = File.read("spec/fixtures/weather/LA_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})
      end

      it "returns all forecast info for a city,state" do
        forecast_facade = ForecastFacade.new

        expect(forecast_facade.forecast_info("Los Angeles, CA")).to be_a(Forecast)
      end
    end

    context "#helper_fetch_lat_lng" do
      before(:each) do
        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=Los%20Angeles,%20CA")
        .to_return(status: 200, body: la_lat_lng, headers: {})
      end

      it "returns a string of coordinates with no spaces" do
        forecast_facade = ForecastFacade.new
        coordinates = forecast_facade.helper_fetch_lat_lng("Los Angeles, CA")

        expect(coordinates).to eq("34.05357,-118.24545")
      end
    end

    # context "#helper_fetch_forecast" do
    #   before(:each) do
    #     la_weather_info = File.read("spec/fixtures/weather/LA_forecast.json")
    #     stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
    #     .to_return(status: 200, body: la_weather_info, headers: {})
    #   end

    #   it "returns a hash of all weather information for the coordinates provided" do
    #     forecast_facade = ForecastFacade.new
    #     weather_info = forecast_facade.helper_fetch_forecast("34.05357,-118.24545")

    #     expect(weather_info).to be_a(Hash)
    #   end
    # end
  end
end