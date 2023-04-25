class RoadTrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta
 
  def initialize(road_trip_info)
    @id = nil
    @start_city = road_trip_info[:start_city]
    @end_city = road_trip_info[:end_city]
    @travel_time = road_trip_info[:travel_time]
    @weather_at_eta = road_trip_info[:weather_at_eta]
  end
end