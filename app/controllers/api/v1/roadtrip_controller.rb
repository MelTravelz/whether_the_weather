class Api::V1::RoadtripController < ApplicationController
  before_action :check_user_credentials, only: [:index]

  def index
# require 'pry'; binding.pry
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