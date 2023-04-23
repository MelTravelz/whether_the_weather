require "rails_helper"

RSpec.describe "/api/v1/forecast" do
  describe "#index" do
    it "returns a json object, forecast type" do
      get '/api/v1/forecast?location=losangeles,ca'

      expect(response).to be_successful
    end
  end
end