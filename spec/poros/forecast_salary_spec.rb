require "rails_helper"

RSpec.describe ForecastSalary, type: :model do
  let(:cool_place_information) {
    {
      destination: "cool-place",
      forecast: { summary: "Freezey-Breezey", temperature: "10 F" },
      salaries:
      [
        { title: "Cool Tech Job 1", min: "$100100.03", max: "$200200.06"},
        { title: "Cool Tech Job 2", min: "$120500.75", max: "$500120.25"}
      ]
    }
  }

  describe "instance methods" do
    describe "#initialize" do
      it "exists & has attributes" do
        cool_place_info = ForecastSalary.new(cool_place_information)

        forecast_hash = { summary: "Freezey-Breezey", temperature: "10 F" }
        salaries_array = 
          [
            { title: "Cool Tech Job 1", min: "$100100.03", max: "$200200.06"},
            { title: "Cool Tech Job 2", min: "$120500.75", max: "$500120.25"}
          ]

        expect(cool_place_info).to be_a(ForecastSalary)
        expect(cool_place_info.id).to eq(nil)

        expect(cool_place_info.destination).to be_a(String)
        expect(cool_place_info.destination).to eq("cool-place")

        expect(cool_place_info.forecast).to be_a(Hash)
        expect(cool_place_info.forecast).to eq(forecast_hash)

        expect(cool_place_info.salaries).to be_an(Array)
        expect(cool_place_info.salaries).to eq(salaries_array)
      end
    end
  end
end