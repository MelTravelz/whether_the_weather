require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    describe "happy path tests" do

      describe "#initialize" do
        it "exists and creates an instance of mapquest service" do
          roadtrip_facade = RoadtripFacade.new

          expect(roadtrip_facade).to be_a(RoadtripFacade)
          expect(roadtrip_facade.mapquest_service).to be_a(MapQuestService)
          # expect(@roadtrip_facade.weather_service).to be_a(WeatherService)
        end
      end
    end 
  end
end
