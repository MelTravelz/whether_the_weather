class ForecastFacade
  attr_reader :mapquest_service,
              :weather_service

  def initialize
    @mapquest_service = MapQuestService.new
    @weather_service = WeatherService.new
  end

  def forecast_info(location_coordinates)
    # coordinates_string = helper_fetch_lat_lng(location_name)
    all_weather_info = weather_service.fetch_forecast(location_coordinates)

    new_all_weather_hash = {
      current_weather: helper_current_weather(all_weather_info),
      daily_weather: helper_daily_weather(all_weather_info),
      hourly_weather: helper_hourly_weather(all_weather_info)
    }

    Forecast.new(new_all_weather_hash)
  end

  ###### Called in Controller ONLY:
  def helper_fetch_lat_lng(location_name)
    info_hash = mapquest_service.fetch_lat_lng(location_name)
    if info_hash[:results].first[:locations].first[:source].present? 
      return "invalid location name"
    else
      "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
    end
  end
  #########

  def helper_5_days(all_weather_info)
    all_weather_info[:forecast][:forecastday].map do |forecast_day|
      forecast_day
    end
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

  def helper_daily_weather(all_weather_info)
    five_days = helper_5_days(all_weather_info)

    five_days.map do |day|
      {
        date: day[:date],
        sunrise: day[:astro][:sunrise],
        sunset: day[:astro][:sunset],
        max_temp: day[:day][:maxtemp_f],
        min_temp: day[:day][:mintemp_f],
        condition: day[:day][:condition][:text],
        icon: day[:day][:condition][:icon]
      }
    end
  end

  def helper_hourly_weather(all_weather_info)
    all_weather_info[:forecast][:forecastday].first[:hour].map do |hourly_w|
      {
        time: hourly_w[:time].chars.last(5).join,
        temperature: hourly_w[:temp_f],
        conditions: hourly_w[:condition][:text],
        icon: hourly_w[:condition][:icon]
      }
    end
  end
end