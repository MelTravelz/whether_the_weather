class MapQuestService
  def fetch_lat_lng(city_state)
    response = conn.get("geocoding/v1/address") do |faraday|
      faraday.params["location"] = city_state
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def fetch_directions(from_coord, to_coord)
    response = conn.get("directions/v2/route") do |faraday|
      faraday.params["from"] = from_coord
      faraday.params["to"] = to_coord
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def conn
    Faraday.new(url: "https://www.mapquestapi.com/") do |faraday|
      faraday.params["key"] = ENV["MAPQUEST_API_KEY"] 
    end
  end
end