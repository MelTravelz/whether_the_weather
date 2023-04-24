require "rails_helper"

RSpec.describe TeleportService do
  describe "instance methods" do
    context "#fetch_area_salaries" do
      it "can return a json object" do
        teleport_la_salaries = File.read("spec/fixtures/teleport/la_salaries.json")
        stub_request(:get, "https://api.teleport.org/api/urban_areas/slug:los-angeles/salaries/")
        .to_return(status: 200, body: teleport_la_salaries, headers: {})

        response = TeleportService.new.fetch_area_salaries("los-angeles")

        expect(response).to be_a(Hash)
        expect(response.keys).to eq([:_links, :salaries])
      end
    end
  end
end