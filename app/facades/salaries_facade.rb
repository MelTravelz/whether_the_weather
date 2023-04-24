class SalariesFacade
  attr_reader :teleport_service

  def initialize
    @teleport_service = TeleportService.new
  end

  def find_salary_and_forecast(destination_name)
    salaries_by_destination = @teleport_service.fetch_area_salaries(destination_name.downcase)
    
    salaries = salaries_by_destination[:salaries].map do |salary_hash|
      require 'pry'; binding.pry
      {
        title: salary_hash[:job][:title],
        min: salary_hash[:salary_percentiles][:percentile_25],
        max: salary_hash[:salary_percentiles][:percentile_75] 
      }
    end
  end

end