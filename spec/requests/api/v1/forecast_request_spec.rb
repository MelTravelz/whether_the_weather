require "rails_helper"

RSpec.describe "/api/v1/forecast" do
  describe "#index" do
    it "returns current, daily, hourly weather + attributes for a city,state" do
      get '/api/v1/forecast?location=losangeles,ca'

      expect(response).to be_successful
    end
  end
end