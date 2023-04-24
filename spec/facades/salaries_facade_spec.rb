require "rails_helper"

RSpec.describe SalariesFacade do
  describe "intance methods" do
    describe "happy path tests" do
      before(:each) do
        teleport_la_salaries = File.read("spec/fixtures/teleport/la_salaries.json")
        stub_request(:get, "https://api.teleport.org/api/urban_areas/slug:los-angeles/salaries/")
        .to_return(status: 200, body: teleport_la_salaries, headers: {})

        la_lat_lng = File.read("spec/fixtures/map_quest/for_final_la_dash_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=los-angeles")
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
          expect(@salaries_facade.forecast_facade).to be_a(ForecastFacade)
        end
      end

      describe "#find_salary_and_forecast" do
        it "returns salary info for specific jobs & forecast for destination" do
          la_forecast_salaries = @salaries_facade.find_salary_and_forecast("los-angeles")
          
          expect(la_forecast_salaries).to be_a(ForecastSalary)
          expect(la_forecast_salaries.id).to eq(nil)
          expect(la_forecast_salaries.destination).to be_a(String)
          expect(la_forecast_salaries.forecast).to be_a(Hash)
          expect(la_forecast_salaries.salaries).to be_an(Array)
        end
      end
    end
  end
end

