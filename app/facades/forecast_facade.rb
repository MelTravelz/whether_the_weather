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
    x = Forecast.new(all_weather_info)
  end

  def helper_fetch_lat_lng(location_name)
    info_hash = mapquest_service.fetch_lat_lng(location_name)
    "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
  end

  # def helper_fetch_forecast(coordinates_string)
  #   info_hash = weather_service.fetch_forecast(coordinates_string)
    
  # end
end