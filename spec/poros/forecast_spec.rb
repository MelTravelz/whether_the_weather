require "rails_helper"

RSpec.describe Forecast, type: :model do
  let(:la_forecast_selected_info) {
    { 
      current_weather: 
        {
          last_updated: "2023-04-22 17:00",  
          temperature: 79, 
          feels_like: 77.4, 
          humidity: 36, 
          uvi: 7, 
          visibility: 9, 
          condition: "Sunny", 
          icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
        },
      daily_weather: 
      [
        {
        date: "2023-04-22", 
        sunrise: "06:13 AM", 
        sunset: "07:30 PM", 
        max_temp: 86.7, 
        min_temp: 64, 
        condition: "Sunny", 
        icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
        },
        {
        date: "2023-04-26", 
        sunrise: "06:09 AM", 
        sunset: "07:33 PM", 
        max_temp: 81.7, 
        min_temp: 58.8, 
        condition: "Sunny", 
        icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
        }
      ],
      hourly_weather: [
        {
        time: "00:00", 
        temperature: 69.8, 
        conditions: "Clear", 
        icon: "//cdn.weatherapi.com/weather/64x64/night/113.png"
        },
        {
        time: "23:00", 
        temperature: 69.8, 
        conditions: "Clear", 
        icon: "//cdn.weatherapi.com/weather/64x64/night/113.png"
        }
      ]
    }
  }

  describe "insatance methods" do
    context "#initialize" do
      it "exists & has attributes" do
        la_forecast = Forecast.new(la_forecast_selected_info)

        expect(la_forecast).to be_a(Forecast)
        expect(la_forecast.id).to eq(nil)
        expect(la_forecast.current_weather).to be_a(Hash)
        expect(la_forecast.current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])

        expect(la_forecast.daily_weather).to be_an(Array)
        expect(la_forecast.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])

        expect(la_forecast.hourly_weather).to be_an(Array)
        expect(la_forecast.hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
      end
    end
  end
end