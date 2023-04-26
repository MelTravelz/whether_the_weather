class Api::V1::ForecastController < ApplicationController
  before_action :check_location_nil, only: [:index]

  def index
    forecast_facade = ForecastFacade.new
    location_coordinates = forecast_facade.find_location_lat_lng(params[:location])

    if location_coordinates == "invalid location name"
      render json: ErrorSerializer.new("404", "Location name is invalid.").invalid_request, status: 404
    else
      all_forecast_info = forecast_facade.find_forecast_info(location_coordinates)
      render json: ForecastSerializer.new(all_forecast_info)
    end
  end

  def check_location_nil
    if params[:location] == "" || params[:location] == nil
      render json: ErrorSerializer.new("404", "Location name cannot be blank.").invalid_request, status: 404
    end
  end
end