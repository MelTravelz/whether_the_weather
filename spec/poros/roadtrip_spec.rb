require "rails_helper"

RSpec.describe Roadtrip, type: :model do
  let(:school_trip) {
    {
      start_city: "Hogwarts, UK",
      end_city: "Stonehenge, UK",
      travel_time: "01:00:45",
      weather_at_eta: 
      {
        datetime: "2023-01-01 01:00",
        temperature: 32,
        condition: "Dark, cold, and mysterious!"
      }
    }
  }

  describe "instance methods" do
    context "#initialize" do
      it "exists & has attributes" do
        school_roadtrip = RoadTrip.new(school_trip)
        
        expect(school_roadtrip).to be_a(Roadtrip)
        expect(school_roadtrip.start_city).to eq("Hogwarts, UK")
        expect(school_roadtrip.end_city).to eq("Stonehenge, UK")
        expect(school_roadtrip.travel_time).to eq("01:00:45")
        expect(school_roadtrip.weather_at_eta).to be_a(Hash)
        expect(school_roadtrip.weather_at_eta.keys).to eq([:datetime, :temperature, :condition])
        expect(school_roadtrip.weather_at_eta[:datetime]).to eq("2023-01-01 01:00")
        expect(school_roadtrip.weather_at_eta[:temperature]).to eq(32)
        expect(school_roadtrip.weather_at_eta[:condition]).to eq("Dark, cold, and mysterious!")
      end
    end
  end
end