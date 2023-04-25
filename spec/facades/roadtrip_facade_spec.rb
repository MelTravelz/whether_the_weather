require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    describe "happy path tests" do
      before(:each) do
        ny_capitalized_lat_lng = File.read("spec/fixtures/map_quest/ny_capitalized_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=New%20York,%20NY")
        .to_return(status: 200, body: ny_capitalized_lat_lng, headers: {})

        la_capitalized_lat_lng = File.read("spec/fixtures/map_quest/la_capitalized_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=Los%20Angeles,%20CA")
        .to_return(status: 200, body: la_capitalized_lat_lng, headers: {})

        ny_la_directions = File.read("spec/fixtures/map_quest/ny_la_directions.json")
        stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=40.71453,-74.00712&key=#{ENV["MAPQUEST_API_KEY"]}&to=34.05357,-118.24545")
        .to_return(status: 200, body: ny_la_directions, headers: {})

        xyz_abc = File.read("spec/fixtures/map_quest/xyzabc_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=xyz,abc")
        .to_return(status: 200, body: xyz_abc, headers: {})

        @roadtrip_facade = RoadtripFacade.new
      end

      describe "#initialize" do
        it "exists and creates an instance of mapquest service" do
          expect(@roadtrip_facade).to be_a(RoadtripFacade)
          expect(@roadtrip_facade.mapquest_service).to be_a(MapQuestService)
          # expect(@roadtrip_facade.weather_service).to be_a(WeatherService)
        end
      end

      describe "#helper_fetch_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @roadtrip_facade.helper_fetch_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end

        it "returns an array with single coordinate when one locaiton name is invalid" do  
          coordinate_array = @roadtrip_facade.helper_fetch_both_lat_lng("New York, NY", "xyz,abc")
          expect(coordinate_array).to eq(["40.71453,-74.00712"])
        end

        it "returns an empty array when both locaiton names are invalid" do  
          coordinate_array = @roadtrip_facade.helper_fetch_both_lat_lng("xyz,abc", "xyz,abc")
          expect(coordinate_array).to eq([])
        end
      end

      describe "#fetch_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @roadtrip_facade.fetch_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end

        it "returns an error message when one or more location names are invalid" do
          error_message = @roadtrip_facade.fetch_both_lat_lng("New York, NY", "xyz,abc")
          expect(coordinate_array).to eq("one or more invalid location names")
        end
      end
    end 
  end
end
