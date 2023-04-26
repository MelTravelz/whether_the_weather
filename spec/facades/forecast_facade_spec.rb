require "rails_helper"

RSpec.describe ForecastFacade do
  describe "intance methods" do
    # For testing real endpoint connection: 
      # before do
      #   WebMock.allow_net_connect!
      # end
      # after do
      #   WebMock.disable_net_connect!
      # end

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
      
      # Los Angeles, CA coordinates = 34.05357,-118.24545
      let(:all_weather_info) { @forecast_facade.weather_service.fetch_forecast("34.05357,-118.24545") }

    describe "happy path tests" do
      describe "#initialize" do
        it "exists and creates an instance of mapquest & weather services" do
          expect(@forecast_facade).to be_a(ForecastFacade)
          expect(@forecast_facade.mapquest_service).to be_a(MapQuestService)
          expect(@forecast_facade.weather_service).to be_a(WeatherService)
        end
      end

      describe "#find_location_lat_lng" do
        it "returns a string of coordinates with no spaces" do
          coordinates = @forecast_facade.find_location_lat_lng("losangeles,ca")
          expect(coordinates).to eq("34.05357,-118.24545")
        end
      end

      describe "#find_forecast_info" do
        it "returns all forecast info for a city,state" do
          # Los Angeles, CA coordinates = 34.05357,-118.24545
          all_la_forecast_info = @forecast_facade.find_forecast_info("34.05357,-118.24545")

          expect(all_la_forecast_info).to be_a(Forecast)
          expect(all_la_forecast_info.id).to eq(nil)

          expect(all_la_forecast_info.current_weather).to be_a(Hash)
          expect(all_la_forecast_info.current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])

          expect(all_la_forecast_info.daily_weather).to be_an(Array)
          expect(all_la_forecast_info.daily_weather.count).to eq(5)
          expect(all_la_forecast_info.daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])

          expect(all_la_forecast_info.hourly_weather).to be_an(Array)
          expect(all_la_forecast_info.hourly_weather.count).to eq(24)
          expect(all_la_forecast_info.hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
        end
      end

      describe "#helper_current_weather" do
        it "returns a hash with 8 attributes" do
          current_weather = @forecast_facade.helper_current_weather(all_weather_info)

          expect(current_weather).to be_a(Hash)
          expect(current_weather.keys).to eq([:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon])
        end
      end

      context "#helper_daily_weather" do
        it "returns an array of hashes with 7 attributes" do
          daily_weather = @forecast_facade.helper_daily_weather(all_weather_info)
          
          expect(daily_weather).to be_an(Array)
          expect(daily_weather.count).to eq(5)
          expect(daily_weather.first.keys).to eq([:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon])
        end
      end
      
      context "#helper_hourly_weather" do
        it "returns an array of hashes with 4 attributes" do
          hourly_weather = @forecast_facade.helper_hourly_weather(all_weather_info)
                   
          expect(hourly_weather).to be_an(Array)
          expect(hourly_weather.count).to eq(24)
          expect(hourly_weather.first.keys).to eq([:time, :temperature, :conditions, :icon])
        end
      end
    end

    describe "sad path tests" do
      describe "#find_location_lat_lng" do
        it "returns an error string when locaiton name is invalid" do  
          error_message = @forecast_facade.find_location_lat_lng("xzy,abc")
          expect(error_message).to eq("invalid location name")
        end
      end
    end
  end
end