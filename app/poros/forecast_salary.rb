class ForecastSalary
  attr_reader :id,
              :destination,
              :forecast,
              :salaries

  def initialize(forecast_salaries_info)
    @id = nil
    @destination = forecast_salaries_info[:destination]
    @forecast = forecast_salaries_info[:forecast]
    @salaries = forecast_salaries_info[:salaries]
  end
end