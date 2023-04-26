class MapQuestService
  def fetch_lat_lng(location_name)
    response = conn.get("geocoding/v1/address") do |faraday|
      faraday.params["location"] = location_name
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  def fetch_directions(from_coord, to_coord)
    response = conn.get("directions/v2/route") do |faraday|
      faraday.params["from"] = from_coord
      faraday.params["to"] = to_coord
    end
    parsed_data = JSON.parse(response.body, symbolize_names: true)
    return [:error] if parsed_data[:info][:statuscode] == 402
    parsed_data
  end

  private

  def conn
    Faraday.new(url: "https://www.mapquestapi.com/") do |faraday|
      faraday.params["key"] = ENV["MAPQUEST_API_KEY"] 
    end
  end
end