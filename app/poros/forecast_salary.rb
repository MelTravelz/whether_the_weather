class ForecastSalary
  attr_reader :destination,
              :forecast,
              :salaries

  def initialize(forecast_salaries_info)
    @destination = forecast_salaries_info[:destination]
    @forecast = forecast_salaries_info[:forecast]
    @salaries = forecast_salaries_info[:salaries]
  end
end