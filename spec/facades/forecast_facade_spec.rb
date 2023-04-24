require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    describe "happy path tests" do
      before(:each) do
        la_lat_lng = File.read("spec/fixtures/map_quest/la_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=losangeles,ca")
        .to_return(status: 200, body: la_lat_lng, headers: {})

        la_weather_info = File.read("spec/fixtures/weather/la_forecast.json")
        stub_request(:get, "http://api.weatherapi.com/v1/forecast.json?days=5&key=#{ENV["WEATHER_API_KEY"]}&q=34.05357,-118.24545")
        .to_return(status: 200, body: la_weather_info, headers: {})

        xyz_abc = File.read("spec/fixtures/map_quest/xyzabc_lat_lng.json")
        stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{ENV["MAPQUEST_API_KEY"]}&location=xzy,abc")
        .to_return(status: 200, body: xyz_abc, headers: {})
        
        @forecast_facade = ForecastFacade.new
      end

      describe "#initialize" do
        it "exists and creates an instance of mapquest & weather services" do
          expect(@forecast_facade).to be_a(ForecastFacade)
          expect(@forecast_facade.mapquest_service).to be_a(MapQuestService)
          expect(@forecast_facade.weather_service).to be_a(WeatherService)
        end
      end

      describe "#forecast_info" do
        it "returns all forecast info for a city,state" do
          # Los Angeles, CA coordinates = 34.05357,-118.24545
          la_forecast_info = @forecast_facade.forecast_info("34.05357,-118.24545")

          expect(la_forecast_info).to be_a(Forecast)
          expect(la_forecast_info.id).to eq(nil)

          expect(la_forecast_info.current_weather).to be_a(Hash)
          expect(la_forecast_info.current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])

          expect(la_forecast_info.daily_weather).to be_an(Array)
          expect(la_forecast_info.daily_weather.count).to eq(5)
          expect(la_forecast_info.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])


          expect(la_forecast_info.hourly_weather).to be_an(Array)
          expect(la_forecast_info.hourly_weather.count).to eq(24)
          expect(la_forecast_info.hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
        end
      end

      describe "#helper_fetch_lat_lng" do
        it "returns a string of coordinates with no spaces" do
          coordinates = @forecast_facade.helper_fetch_lat_lng("losangeles,ca")
          expect(coordinates).to eq("34.05357,-118.24545")
        end

        it "returns an error string when locaiton name is invalid" do  
          error_message = @forecast_facade.helper_fetch_lat_lng("xzy,abc")
          expect(error_message).to eq("invalid location name")
        end
      end

      describe "#heler_5_days" do
        it "returns an array of 5 hashes of weather forecast days" do
          weather_service = @forecast_facade.weather_service
          all_weather_info = weather_service.fetch_forecast("34.05357,-118.24545")
          five_days = @forecast_facade.helper_5_days(all_weather_info)

          expect(five_days).to be_an(Array)
          expect(five_days.count).to eq(5)
          expect(five_days.first).to be_a(Hash)
          expect(five_days.first.keys).to eq([:date, :date_epoch, :day, :astro, :hour])

          expect(five_days.first[:date]).to eq("2023-04-22")
          expect(five_days.first[:date_epoch]).to eq(1682121600)

          expect(five_days.first[:day]).to be_a(Hash)
          expect(five_days.first[:day].keys.count).to eq(20)

          expect(five_days.first[:astro]).to be_a(Hash)
          expect(five_days.first[:astro].keys.count).to eq(8)

          expect(five_days.first[:hour]).to be_an(Array)
          expect(five_days.first[:hour].first).to be_a(Hash)
          expect(five_days.first[:hour].first.keys.count).to eq(33)
        end
      end

      describe "#helper_current_weather" do
        it "returns a hash with 8 attributes" do
          weather_service = @forecast_facade.weather_service
          all_weather_info = weather_service.fetch_forecast("34.05357,-118.24545")
          current_weather = @forecast_facade.helper_current_weather(all_weather_info)

          expected_hash = {
            last_updated: "2023-04-22 17:00",
            temperature: 79,
            feels_like: 77.4,
            humidity:36,
            uvi: 7,
            visibility: 9,
            condition: "Sunny",
            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
          }

          expect(current_weather).to be_a(Hash)
          expect(current_weather).to eq(expected_hash)
        end
      end

      context "#helper_daily_weather" do
        it "returns an array of hashes with 7 attributes" do
          weather_service = @forecast_facade.weather_service
          all_weather_info = weather_service.fetch_forecast("34.05357,-118.24545")
          daily_weather = @forecast_facade.helper_daily_weather(all_weather_info)
          
          expected_hash = {
            date: "2023-04-22",
            sunrise: "06:13 AM",
            sunset: "07:30 PM",
            max_temp: 86.7,
            min_temp: 64, 
            condition: "Sunny",
            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
          }
          
          expect(daily_weather).to be_an(Array)
          expect(daily_weather.count).to eq(5)
          expect(daily_weather.first).to eq(expected_hash)
        end
      end
      
      context "#helper_hourly_weather" do
        it "returns an array of hashes with 4 attributes" do
          weather_service = @forecast_facade.weather_service
          all_weather_info = weather_service.fetch_forecast("34.05357,-118.24545")
          hourly_weather = @forecast_facade.helper_hourly_weather(all_weather_info)
          
          expected_hash = {
            time: "00:00",
            temperature: 69.8,
            conditions: "Clear",
            icon: "//cdn.weatherapi.com/weather/64x64/night/113.png"
          }
                   
          expect(hourly_weather).to be_an(Array)
          expect(hourly_weather.count).to eq(24)
          expect(hourly_weather.first).to eq(expected_hash)
        end
      end
    end
  end
end