class TeleportService
  def fetch_area_salaries(location_name) #don't forget to downcase the city name!!
    response = conn.get("urban_areas/slug:#{location_name}/salaries/") 
    JSON.parse(response.body, symbolize_names: true)
  end

  private
  
  def conn
    Faraday.new(url: "https://api.teleport.org/api/")
  end
end