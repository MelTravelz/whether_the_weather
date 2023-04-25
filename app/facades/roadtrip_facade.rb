class RoadtripFacade
  attr_reader :mapquest_service #,
              # :weather_service

  def initialize
    @mapquest_service = MapQuestService.new
    # @weather_service = WeatherService.new
  end

  def fetch_both_lat_lng(from_origin, to_destination)
    coord_array = helper_fetch_both_lat_lng(from_origin, to_destination)
    return "one or more invalid location names" if coord_array.count != 2  
  end


  def helper_fetch_both_lat_lng(from_origin, to_destination)
    location_array = [from_origin, to_destination]
    coord_array = location_array.map do |location_name|
      info_hash = mapquest_service.fetch_lat_lng(location_name)
      if info_hash[:results].first[:locations].first[:source].present? 
        nil
      else
        "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
      end
    end.compact
  end

    ###### 
    # def helper_fetch_lat_lng(location_name)
    #   info_hash = mapquest_service.fetch_lat_lng(location_name)
    #   if info_hash[:results].first[:locations].first[:source].present? 
    #     return "invalid location name"
    #   else
    #     "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
    #   end
    # end
    #########


end