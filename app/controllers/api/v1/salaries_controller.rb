class Api::V1::SalariesController < ApplicationController
  def index
    salaries_and_forecast = SalariesFacade.new.find_salary_and_forecast(params[:destination])
    # render json: SalariesSerializer.new(salaries_and_forecast)
  end
end