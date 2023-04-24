class SalariesFacade
  attr_reader :teleport_service,
              :forecast_facade

  def initialize
    @teleport_service = TeleportService.new
    @forecast_facade = ForecastFacade.new
  end

  def find_salary_and_forecast(destination_name)
    salaries_by_destination = @teleport_service.fetch_area_salaries(destination_name.downcase)
    
    # gest salaries info -> refactor into helper method
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

    # get forecast info -> also a helper method
    coord = @forecast_facade.helper_fetch_lat_lng(destination_name)
    all_weather_info = @forecast_facade.weather_service.fetch_forecast(coord)
    current_w = @forecast_facade.helper_current_weather(all_weather_info)
    

    new_hash = {
      forecast: {
        summary: current_w[:temperature],
        temperature: "#{current_w[:condition]} F"
      },
      salaries: salaries_array
    }
require 'pry'; binding.pry

  end

end