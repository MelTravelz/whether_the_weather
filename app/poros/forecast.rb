class Forecast 
  attr_reader :id,
              :current_weather,
              :daily_weather,
              :hourly_weather

  def initialize(all_weather_info)
    @id = nil
    @current_weather = all_weather_info[:current_weather]
    @daily_weather = all_weather_info[:daily_weather]
    @hourly_weather = all_weather_info[:hourly_weather]
  end
end