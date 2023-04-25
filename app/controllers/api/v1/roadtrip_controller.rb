class Api::V1::RoadtripController < ApplicationController
  before_action :check_user_credentials, only: [:index]

  def index
    roadtrip_facade = RoadtripFacade.new
    location_coordinates = roadtrip_facade.fetch_both_lat_lng(roadtrip_params[:origin], roadtrip_params[:destination])

    if location_coordinates == "one or more invalid location names"
      render json: ErrorSerializer.new("One or more location names are invalid.").invalid_request, status: 404
    else
      all_direction_weather_info = forecast_facade.direction_weather_info(location_coordinates)
      render json: RoadtripSerializer.new(all_direction_weather_info)
    end
  end

  private
  def check_user_credentials
    if  roadtrip_params[:api_key] == nil || User.find_by(api_key: roadtrip_params[:api_key]) == nil
      render json: ErrorSerializer.new("Unauthorized request.").invalid_request, status: 401
    end
  end

  def roadtrip_params
    params.require(:roadtrip).permit(:origin, :destination, :api_key)
  end
end