class WeatherService
  def fetch_forecast(coordinates)
    response = conn.get("v1/forecast.json") do |faraday|
      faraday.params["q"] = coordinates
      faraday.params["days"] = 5
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "http://api.weatherapi.com/") do |faraday|
      faraday.params["key"] = ENV["WEATHER_API_KEY"] 
    end
  end
end