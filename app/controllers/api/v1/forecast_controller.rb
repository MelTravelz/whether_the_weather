class Api::V1::ForecastController < ApplicationController
  def index
    all_forcast_info = ForecastFacade.new.forecast_info(params[:location])
    # render json: ForecastSerializer.new(all_forcast_info)
  end
end