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
      ny_lat_lng = File.read("spec/fixtures/map_quest/ny_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=newyork,ny")
      .to_return(status: 200, body: ny_lat_lng, headers: {})

      la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
      .to_return(status: 200, body: la_lat_lng, headers: {})

      xyz_abc = File.read("spec/fixtures/map_quest/xyzabc_lat_lng.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=xyz,abc")
      .to_return(status: 200, body: xyz_abc, headers: {})

      ny_la_directions = File.read("spec/fixtures/map_quest/ny_la_directions.json")
      stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=40.71453,-74.00712&key=#{ENV["MAPQUEST_API_KEY"]}&to=34.05357,-118.24545")
      .to_return(status: 200, body: ny_la_directions, headers: {})

      la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
      stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
      .to_return(status: 200, body: la_weather_info, headers: {})

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

      describe "#helper_fetch_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end

        it "returns an array with single coordinate when one locaiton name is invalid" do  
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("New York, NY", "xyz,abc")
          expect(coordinate_array).to eq(["40.71453,-74.00712"])
        end

        it "returns an empty array when both locaiton names are invalid" do  
          coordinate_array = @road_trip_facade.helper_fetch_both_lat_lng("xyz,abc", "xyz,abc")
          expect(coordinate_array).to eq([])
        end
      end

      describe "#fetch_both_lat_lng" do
        it "returns an array of both location coordinates" do
          coordinate_array = @road_trip_facade.fetch_both_lat_lng("New York, NY", "Los Angeles, CA")
          expect(coordinate_array).to eq(["40.71453,-74.00712", "34.05357,-118.24545"])
        end

        it "returns an error message when one or more location names are invalid" do
          error_message = @road_trip_facade.fetch_both_lat_lng("New York, NY", "xyz,abc")
          expect(error_message).to eq("one or more invalid location names")
        end
      end

      describe "#fetch_road_trip_info" do 
        it "returns a road_trip object" do
          road_trip_info = @road_trip_facade.fetch_road_trip_info(["New York, NY", "Los Angeles, CA"], ["40.71453,-74.00712", "34.05357,-118.24545"])
          
          expect(road_trip_info).to be_a(RoadTrip)
          expect(road_trip_info.start_city).to be_a(String)
          expect(road_trip_info.end_city).to be_a(String)
          expect(road_trip_info.travel_time).to be_a(String)
          expect(road_trip_info.weather_at_eta).to be_a(Hash)
          expect(road_trip_info.weather_at_eta.keys).to eq([:datetime, :temperature, :condition])
        end
      end

      describe "#helper_fetch_direction_times" do
        it "returns all direction instructions" do
          # New York, NY coordinates = 40.71453,-74.00712
          # Los Angeles, CA coordinates = 34.05357,-118.24545
          ny_la_arrival_times = @road_trip_facade.helper_fetch_direction_times(["40.71453,-74.00712", "34.05357,-118.24545"])
          expect(ny_la_arrival_times).to be_a(Hash)
          expect(ny_la_arrival_times.keys).to eq([:total_travel_time, :seconds_to_arrival])
        end
      end
    end 
  end
end
