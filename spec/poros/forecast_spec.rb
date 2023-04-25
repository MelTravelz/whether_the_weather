require "rails_helper"

RSpec.describe Forecast, type: :model do
  let(:hogwarts_forecast_info) {
    { 
      current_weather: 
        {
          last_updated: "2023-01-01 17:00",  
          temperature: 31, 
          feels_like: 0.4, 
          humidity: 55, 
          uvi: 7, 
          visibility: 9, 
          condition: "Stormy", 
          icon: "/watchtower/weather.png"
        },
      daily_weather: 
      [
        {
        date: "2023-01-02", 
        sunrise: "06:13 AM", 
        sunset: "07:30 PM", 
        max_temp: 100, 
        min_temp: 32, 
        condition: "Still Stormy", 
        icon: "/quidditch_pitch/weather.png"
        },
        {
        date: "2023-01-03", 
        sunrise: "06:09 AM", 
        sunset: "07:33 PM", 
        max_temp: 99, 
        min_temp: 2, 
        condition: "Even More Stormy", 
        icon: "/forbidden_forest/weather.png"
        }
      ],
      hourly_weather: [
        {
        time: "00:00", 
        temperature: 25, 
        conditions: "Super Clear from some Strange Reason?", 
        icon: "/owlery/weather.png"
        },
        {
        time: "23:00", 
        temperature: 20, 
        conditions: "Super Stormy", 
        icon: "/great_lake/weather.png"
        }
      ]
    }
  }

  describe "insatance methods" do
    context "#initialize" do
      it "exists & has attributes" do
        hogwarts_forecast = Forecast.new(hogwarts_forecast_info)

        expect(hogwarts_forecast).to be_a(Forecast)
        expect(hogwarts_forecast.id).to eq(nil)

        expect(hogwarts_forecast.current_weather).to be_a(Hash)
        expect(hogwarts_forecast.current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])
        expect(hogwarts_forecast.current_weather[:last_updated]).to eq("2023-01-01 17:00")
        expect(hogwarts_forecast.current_weather[:temperature]).to eq(31)
        expect(hogwarts_forecast.current_weather[:feels_like]).to eq(0.4)
        expect(hogwarts_forecast.current_weather[:humidity]).to eq(55)
        expect(hogwarts_forecast.current_weather[:uvi]).to eq(7)
        expect(hogwarts_forecast.current_weather[:visibility]).to eq(9)
        expect(hogwarts_forecast.current_weather[:condition]).to eq("Stormy")
        expect(hogwarts_forecast.current_weather[:icon]).to eq("/watchtower/weather.png")

        expect(hogwarts_forecast.daily_weather).to be_an(Array)
        expect(hogwarts_forecast.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
        expect(hogwarts_forecast.daily_weather.first[:date]).to eq("2023-01-02")
        expect(hogwarts_forecast.daily_weather.first[:sunrise]).to eq("06:13 AM")
        expect(hogwarts_forecast.daily_weather.first[:sunset]).to eq("07:30 PM")
        expect(hogwarts_forecast.daily_weather.first[:max_temp]).to eq(100)
        expect(hogwarts_forecast.daily_weather.first[:min_temp]).to eq(32)
        expect(hogwarts_forecast.daily_weather.first[:condition]).to eq("Still Stormy")
        expect(hogwarts_forecast.daily_weather.first[:icon]).to eq("/quidditch_pitch/weather.png")

        expect(hogwarts_forecast.hourly_weather).to be_an(Array)
        expect(hogwarts_forecast.hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
        expect(hogwarts_forecast.hourly_weather.first[:time]).to eq("00:00")
        expect(hogwarts_forecast.hourly_weather.first[:temperature]).to eq(25)
        expect(hogwarts_forecast.hourly_weather.first[:conditions]).to eq("Super Clear from some Strange Reason?")
        expect(hogwarts_forecast.hourly_weather.first[:icon]).to eq("/owlery/weather.png")
      end
    end
  end
end