class ForecastFacade
  attr_reader :mapquest_service,
              :weather_service

  def initialize
    @mapquest_service = MapQuestService.new
    @weather_service = WeatherService.new
  end

  def forecast_info(location_name)
    coordinates_string = helper_fetch_lat_lng(location_name)
    all_weather_info = weather_service.fetch_forecast(coordinates_string)

    new_hash = {
      current_weather: helper_current_weather(all_weather_info),
      # daily_weather: helper_daily_weather(all_weather_info),
      # hourly_weather: helper_hourly_weather(all_weather_info)
    }

    x = Forecast.new(new_hash)
    # x = Forecast.new(all_weather_info)
  end

  def helper_fetch_lat_lng(location_name)
    info_hash = mapquest_service.fetch_lat_lng(location_name)
    "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
  end

  def helper_current_weather(all_weather_info)
    {
      last_updated: all_weather_info[:current][:last_updated],
      temperature: all_weather_info[:current][:temp_f],
      feels_like: all_weather_info[:current][:feelslike_f],
      humidity: all_weather_info[:current][:humidity],
      uvi: all_weather_info[:current][:uv],
      visibility: all_weather_info[:current][:vis_miles],
      condition: all_weather_info[:current][:condition][:text],
      icon: all_weather_info[:current][:condition][:icon]
    }
  end
end