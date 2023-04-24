class SalariesFacade
  attr_reader :teleport_service

  def initialize
    @teleport_service = TeleportService.new
  end

  def find_salary_and_forecast(destination_name)
    salaries_by_destination = @teleport_service.fetch_area_salaries(destination_name.downcase)
    
    salaries_array = salaries_by_destination[:salaries].map do |salary_hash|
      tech_job = salary_hash[:job][:title]
      if tech_job == "Data Analyst" || tech_job == "Data Scientist" || tech_job == "Mobile Developer" || tech_job == "QA Engineer" || tech_job == "Software Engineer" || tech_job == "Systems Administrator" || tech_job == "Web Developer"
        {
          title: tech_job,
          min: salary_hash[:salary_percentiles][:percentile_25],
          max: salary_hash[:salary_percentiles][:percentile_75] 
        }
      end
    end.compact
require 'pry'; binding.pry
    # salaries.find_by
    # salaries.find do |salary|
    # if salary[:title] == "Data Analyst" || salary[:title] == "Data Scientist" 

  end

end