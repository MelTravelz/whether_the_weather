require "rails_helper"

RSpec.describe MapQuestService do
  describe "instance methods" do
    context "#fetch_lat_lng" do
      it "returns json object" do
        ny_lat_lng = File.read("spec/fixtures/map_quest/ny_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=newyork,ny")
        .to_return(status: 200, body: ny_lat_lng, headers: {})

        response = MapQuestService.new.fetch_lat_lng("newyork,ny")
        keys = %i[info options results]

        expect(response).to be_a(Hash)
        expect(response.keys).to eq(keys)
      end
    end

    context "#fetch_directions" do
      it "returns json object" do
        ny_la_directions = File.read("spec/fixtures/map_quest/ny_la_directions.json")
        stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=40.71453,-74.00712&key=#{ENV["MAPQUEST_API_KEY"]}&to=34.05357,-118.24545")
        .to_return(status: 200, body: ny_la_directions, headers: {})

        # New York, NY coordinates = 40.71453,-74.00712
        # Los Angeles, CA coordinates = 34.05357,-118.24545
        response = MapQuestService.new.fetch_directions("40.71453,-74.00712", "34.05357,-118.24545")
        keys = %i[route info]

        expect(response).to be_a(Hash)
        expect(response.keys).to eq(keys)
      end
    end

  end
end