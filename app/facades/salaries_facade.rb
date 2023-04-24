class SalariesFacade
  attr_reader :teleport_service
  
  def initialize
    @teleport_service = TeleportService.new
  end

  def find_salary_and_forecast(destination_name)


  end

end