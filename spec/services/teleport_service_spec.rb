require "rails_helper"

RSpec.describe TeleportService do
  describe "instance methods" do
    context "#fetch_area" do
      it "can return a json object" do
        response = TeleportService.new.METHOD_NAME_HERE
        expect(response).to be_a(Hash)
        expect(response.keys).to eq([KEY NAMES HERE])
      end
    end
  end
end