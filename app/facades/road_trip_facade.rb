class RoadTripFacade
  attr_reader :mapquest_service,
              :weather_service

  def initialize
    @mapquest_service = MapQuestService.new
    @weather_service = WeatherService.new
  end

  def find_both_lat_lng(from_origin, to_destination)
    coord_array = helper_fetch_both_lat_lng(from_origin, to_destination)
    if coord_array.count != 2  
      return "one or more invalid location names" 
    else
      coord_array
    end
  end

  def helper_fetch_both_lat_lng(from_origin, to_destination)
    location_array = [from_origin, to_destination]
    coord_array = location_array.map do |location_name|
      clean_location_name = location_name.downcase.delete(' ')
      info_hash = mapquest_service.fetch_lat_lng(clean_location_name)
      if info_hash[:results].first[:locations].first[:source].present? 
        nil
      else
        "#{info_hash[:results].first[:locations].first[:latLng][:lat]},#{info_hash[:results].first[:locations].first[:latLng][:lng]}"
      end
    end.compact
  end

  def find_road_trip_forecast(location_names, location_coords)
    arrival_times = helper_fetch_direction_times(location_coords)
    all_weather_info = @weather_service.fetch_forecast(location_coords[1])
    arrival_hour_forecast = helper_arrival_forecast(all_weather_info, arrival_times[:seconds_to_arrival])
    new_hash = {
      start_city: location_names[0],
      end_city: location_names[1],
      travel_time: arrival_times[:total_travel_time],
      weather_at_eta: 
      {
        datetime: arrival_hour_forecast[:time],
        temperature: arrival_hour_forecast[:temp_f],
        condition: arrival_hour_forecast[:condition][:text]
      }
    }
    RoadTrip.new(new_hash)
  end

  def helper_fetch_direction_times(location_coords)
    directions_hash = mapquest_service.fetch_directions(location_coords[0], location_coords[1])
    { total_travel_time: directions_hash[:route][:formattedTime],
      seconds_to_arrival: directions_hash[:route][:time] #Could use: [:realTime] only small time difference
    } 
  end

  def helper_arrival_forecast(all_weather_info, travel_seconds)
    arrival_day_time = (Time.now + travel_seconds.seconds)
    arrival_day_forecast = all_weather_info[:forecast][:forecastday].find do |day_hash|
      day_hash[:date] == arrival_day_time.to_s[0, 10]
    end
    arrival_hour_forecast = arrival_day_forecast[:hour].find do |hour_hash|
      hour_hash[:time] == arrival_day_time.to_s[0, 14] + "00"
    end
  end
end