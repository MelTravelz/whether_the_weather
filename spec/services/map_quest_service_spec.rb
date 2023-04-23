require "rails_helper"

RSpec.describe MapQuestService do
  describe "instance methods" do
    context "#fetch_lat_lng" do
      it "returns json object" do
        roswell_lat_lng = File.read("spec/fixtures/map_quest/roswell_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=Roswell,%20NM")
        .to_return(status: 200, body: roswell_lat_lng, headers: {})

        expect(MapQuestService.new.fetch_lat_lng("Roswell, NM")).to be_a(Hash)
      end
    end

    context "#fetch_directions" do
      it "returns json object" do
        roswell_la_directions = File.read("spec/fixtures/map_quest/roswell_la_directions.json")
        stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=33.39509,-104.52275&key=#{ENV["MAPQUEST_API_KEY"]}&to=34.05357,-118.24545")
        .to_return(status: 200, body: roswell_la_directions, headers: {})

        # Roswell, NM coordinates = 33.39509,-104.52275
        # Los Angeles, CA coordinates = 34.05357,-118.24545
        expect(MapQuestService.new.fetch_directions("33.39509,-104.52275", "34.05357,-118.24545")).to be_a(Hash)
      end
    end

  end
end