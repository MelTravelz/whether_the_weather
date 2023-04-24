class TeleportService
  def fetch_area_salaries(location_name) #don't forget to downcase the city name!!
    response = conn.get("urban_areas/slug:#{location_name}/salaries/") 
    JSON.parse(response.body, symbolize_names: true)
  end

  # #example: if consuming more than one endpoint!
  # def fetch_api(url)
  #   response = conn.get(url)
  #   JSON.parse(response.body, symbolize_names: true)
  # end
  
  # def get_urban_areas
  #   fetch_api("urban_areas/")
  # end

  # def get_urban_area_with_slug(city_word) #don't forget to downcase the city name!!
  #   fetch_api("urban_areas/slug:#{city_word}/")
  # end
  # then: 

  # def get_urban_area_details_ua_id(ua_id) #don't forget to downcase the city name!!
  #   fetch_api("urban_areas/teleport:#{ua_id}/details/")
  # end

  private

  def conn
    Faraday.new(url: "https://api.teleport.org/api/")
  end
end