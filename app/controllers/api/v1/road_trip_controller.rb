class Api::V1::RoadTripController < ApplicationController
  before_action :check_user_credentials, only: [:index]
  before_action :check_locations_nil, only: [:index]

  def index
    # @current_user (would need this line to call on current user if had other actions)
    road_trip_facade = RoadTripFacade.new
    location_coordinates = road_trip_facade.find_both_lat_lng(road_trip_params[:origin], road_trip_params[:destination])

    if location_coordinates == "one or more invalid location names"
      render json: ErrorSerializer.new("404", "One or more location names are invalid.").invalid_request, status: 404
    else
      location_names = [road_trip_params[:origin], road_trip_params[:destination]]
      road_trip_forecast = road_trip_facade.find_road_trip_forecast(location_names, location_coordinates)

      if road_trip_forecast == "impossible trip"
        render json: ErrorSerializer.new("404", "Locations provided are an impossible roadtrip.").invalid_request, status: 404
      else
        render json: RoadTripSerializer.new(road_trip_forecast)
      end
    end
  end

  # possible ways to logout:
  # def logout
  #   reset_session
  #   reset_session(@current_user.id)
  # end

  private
  def check_user_credentials
    if road_trip_params[:api_key] == nil || User.find_by(api_key: road_trip_params[:api_key]) == nil
      render json: ErrorSerializer.new("401", "Unauthorized request.").invalid_request, status: 401
    end
  end

  def check_locations_nil
    if road_trip_params[:origin] == nil || road_trip_params[:destination] == nil || road_trip_params[:origin] == "" || road_trip_params[:destination] == ""
      render json: ErrorSerializer.new("404", "One or more location names are missing.").invalid_request, status: 404
    end
  end

  def road_trip_params
    params.require(:road_trip).permit(:origin, :destination, :api_key)
  end
end