class Api::V1::ForecastController < ApplicationController
  def index
    all_forecast_info = ForecastFacade.new.forecast_info(params[:location])
    render json: ForecastSerializer.new(all_forecast_info)
  end
end