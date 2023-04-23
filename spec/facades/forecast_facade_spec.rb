require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    describe "happy path tests" do
      before(:each) do
        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=Los%20Angeles,%20CA")
        .to_return(status: 200, body: la_lat_lng, headers: {})

        la_weather_info = File.read("spec/fixtures/weather/LA_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})

        @forecast_facade = ForecastFacade.new
      end

      context "#initialize" do
        it "exists and creates an instance of mapquest & weather services" do
          expect(@forecast_facade).to be_a(ForecastFacade)
          expect(@forecast_facade.mapquest_service).to be_a(MapQuestService)
          expect(@forecast_facade.weather_service).to be_a(WeatherService)
        end
      end

      context "#forecast_info" do
        it "returns all forecast info for a city,state" do
          expect(@forecast_facade.forecast_info("Los Angeles, CA")).to be_a(Forecast)
          # NOT FINISHED!
        end
      end

      context "#helper_fetch_lat_lng" do
        it "returns a string of coordinates with no spaces" do
          coordinates = @forecast_facade.helper_fetch_lat_lng("Los Angeles, CA")

          expect(coordinates).to eq("34.05357,-118.24545")
        end
      end

      context "#helper_current_weather" do
        it "returns a string of coordinates with no spaces" do
          weather_service = @forecast_facade.weather_service
          la_forecast = weather_service.fetch_forecast("34.05357,-118.24545")
          current_weather = @forecast_facade.helper_current_weather(la_forecast)

          expect(current_weather).to be_a(Hash)
          expect(current_weather[:last_updated]).to eq("2023-04-22 17:00")
          expect(current_weather[:temperature]).to eq(79)
          expect(current_weather[:feels_like]).to eq(77.4)
          expect(current_weather[:humidity]).to eq(36)
          expect(current_weather[:uvi]).to eq(7)
          expect(current_weather[:visibility]).to eq(9)
          expect(current_weather[:condition]).to eq("Sunny")
          expect(current_weather[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
        end
      end

      context "#helper_daily_weather" do
        xit "returns a string of coordinates with no spaces" do
          weather_service = @forecast_facade.weather_service
          la_forecast = weather_service.fetch_forecast("34.05357,-118.24545")
          daily_weather = @forecast_facade.helper_daily_weather(la_forecast)
          #daily_weather not returning what the method is returning? 
          
          expect(daily_weather).to be_an(Array)
          expect(daily_weather.first[:date]).to eq("2023-04-22")
          expect(daily_weather.first[:sunrise]).to eq("06:13 AM")
          expect(daily_weather.first[:sunset]).to eq("07:30 PM")
          expect(daily_weather.first[:max_temp]).to eq(86.7)
          expect(daily_weather.first[:min_temp]).to eq(64)
          expect(daily_weather.first[:condition]).to eq("Sunny")
          expect(daily_weather.first[:icon]).to eq("//cdn.weatherapi.com/weather/64x64/day/113.png")
        end
      end
      
    end
  end
end