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
  end
end