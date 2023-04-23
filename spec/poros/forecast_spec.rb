require "rails_helper"

RSpec.describe Forecast, type: :model do
  describe "instance methods" do
    before(:each) do
      la_forecast_json = File.read("spec/fixtures/weather/LA_forecast.json")
      @la_forecast = JSON.parse(la_forecast_json, symbolize_names: true)
    end
    
    context "#initialize" do
      it "exists & has attributes" do
        la_forecast_selected_info = Forecast.new(@la_forecast)

        expect(la_forecast_selected_info).to be_a(Forecast)
      end
    end
  end
end