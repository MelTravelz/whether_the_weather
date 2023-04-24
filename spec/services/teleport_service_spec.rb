require "rails_helper"

RSpec.describe TeleportService do
  describe "instance methods" do
    context "#fetch_area_salaries" do
      it "can return a json object" do
        teleport_chicago_salaries = File.read("spec/fixtures/teleport/chicago_salaries.json")
        stub_request(:get, "https://api.teleport.org/api/urban_areas/slug:chicago/salaries/")
        .to_return(status: 200, body: teleport_chicago_salaries, headers: {})

        response = TeleportService.new.fetch_area_salaries("chicago")

        expect(response).to be_a(Hash)
        # expect(response.keys).to eq([KEY NAMES HERE])
      end
    end
  end
end