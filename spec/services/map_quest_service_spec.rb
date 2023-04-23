require "rails_helper"

RSpec.describe MapQuestService do
  describe "instance methods" do
    context "#fetch_lat_lng" do
      it "returns json object" do
        expect(MapQuestService.new.fetch_lat_lng("Roswell, NM")).to be_a(Hash)
        expect(MapQuestService.new.fetch_lat_lng("Los Angeles, CA")).to be_a(Hash)
      end
    end

    context "#fetch_directions" do
      it "returns json object" do
        # Roswell, NM coordinates = 33.39509,-104.52275
        # Los Angeles, CA coordinates = 34.05357,-118.24545
        expect(MapQuestService.new.fetch_directions("33.39509,-104.52275", "34.05357,-118.24545")).to be_a(Hash)
      end
    end

  end
end