require "rails_helper"

RSpec.describe RoadTripFacade do
  describe "intance methods" do
    # always leave this on (it uses Time.now):
      before do
        WebMock.allow_net_connect!
      end
      after do
        WebMock.disable_net_connect!
      end

    before(:each) do
      @road_trip_facade = RoadTripFacade.new
    end

    describe "happy path tests" do
      describe "#initialize" do
        it "exists and creates an instance of mapquest service" do
          expect(@road_trip_facade).to be_a(RoadTripFacade)
          expect(@road_trip_facade.mapquest_service).to be_a(MapQuestService)
          expect(@road_trip_facade.weather_service).to be_a(WeatherService)
        end
      end

      describe "#find_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @road_trip_facade.find_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end
      end

      describe "#helper_fetch_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end
      end

      describe "#find_road_trip_forecast" do 
        it "returns a road_trip object" do
          road_trip_info = @road_trip_facade.find_road_trip_forecast(["New York, NY", "Los Angeles, CA"], ["40.71453,-74.00712", "34.05357,-118.24545"])
          
          expect(road_trip_info).to be_a(RoadTrip)
          expect(road_trip_info.start_city).to be_a(String)
          expect(road_trip_info.end_city).to be_a(String)
          expect(road_trip_info.travel_time).to be_a(String)
          expect(road_trip_info.weather_at_eta).to be_a(Hash)
          expect(road_trip_info.weather_at_eta.keys).to eq([:datetime, :temperature, :condition])
        end
      end

      describe "#helper_arrival_forecast" do
        it "returns the forecast hash for the arrival hour" do
          # New York, NY coordinates = 40.71453,-74.00712
          # Los Angeles, CA coordinates = 34.05357,-118.24545
          all_la_weather_info = @road_trip_facade.weather_service.fetch_forecast("34.05357,-118.24545")
          travel_seconds = 144642

          la_arrival_hour_forecast = @road_trip_facade.helper_arrival_forecast(all_la_weather_info, travel_seconds)

          expect(la_arrival_hour_forecast).to be_a(Hash)
          expect(la_arrival_hour_forecast.keys.count).to eq(33)
        end
      end
    end 

    describe "sad path tests" do
      describe "#find_both_lat_lng" do
        it "returns an error message when one or more location names are invalid" do
          error_message = @road_trip_facade.find_both_lat_lng("New York, NY", "xyz,abc")
          expect(error_message).to eq("one or more invalid location names")
        end
      end

      describe "#helper_fetch_both_lat_lng" do
        it "returns an array with single coordinate when one locaiton name is invalid" do  
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("New York, NY", "xyz,abc")
          expect(coordinate_array).to eq(["40.71453,-74.00712"])
        end

        it "returns an empty array when both locaiton names are invalid" do  
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("xyz,abc", "xyz,abc")
          expect(coordinate_array).to eq([])
        end
      end
    end
  end
end
