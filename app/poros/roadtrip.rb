class Roadtrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta
 
  def initialize(roadtrip_info)
    @id = nil
    @start_city = roadtrip_info[:start_city]
    @end_city = roadtrip_info[:end_city]
    @travel_time = roadtrip_info[:travel_time]
    @weather_at_eta = roadtrip_info[:weather_at_eta]
  end
end