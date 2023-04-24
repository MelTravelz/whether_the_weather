class TeleportService
  def fetch_area(?)
    response = conn.get("") do |faraday|
      faraday.params["XXXXX"] = XXXXXX
      faraday.params["XXXXXX"] = XXXXXXX
    end
    JSON.parse(response.body, symbolize_names: true)
  end

  # #example: if consuming more than one endpoint!
  # def fetch_api(url)
  #   response = connection.get(url)
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