require "rails_helper"

RSpec.describe SalariesFacade do
  describe "intance methods" do
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

        @salaries_facade = SalariesFacade.new
      end

      describe "#initialize" do
        it "exists and creates an instance of mapquest & weather services & forecast facade" do
          expect(@salaries_facade).to be_a(SalariesFacade)
          expect(@salaries_facade.teleport_service).to be_a(TeleportService)
          # expect(@salaries_facade.forecast_facade).to be_a(ForecastFacade)
          # expect(@salaries_facade.mapquest_service).to be_a(MapQuestService)
          # expect(@salaries_facade.weather_service).to be_a(WeatherService)
        end
      end
    end
  end
end

