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
            min: "$#{sprintf("%.2f", salary_hash[:salary_percentiles][:percentile_25])}",
            max: "$#{sprintf("%.2f", salary_hash[:salary_percentiles][:percentile_75])}"

          # Original Code:
          # min: "$#{(salary_hash[:salary_percentiles][:percentile_25]).truncate(2)}",
          # max: "$#{(salary_hash[:salary_percentiles][:percentile_75].truncate(2))}"

          # Didn't get word back from instructors if I can use this gem:
          # http://vaidehijoshi.github.io/blog/2015/02/10/money-makes-the-world-go-round-using-money-rails-and-bigdecimal/
          # min: Money.new(salary_hash[:salary_percentiles][:percentile_25], "USD").format,
        }
      end
    end.compact

    # get forecast info -> also a helper method
    coord = @forecast_facade.helper_fetch_lat_lng(destination_name)
    all_weather_info = @forecast_facade.weather_service.fetch_forecast(coord)
    current_w = @forecast_facade.helper_current_weather(all_weather_info)
    

    new_hash = {
      destination: destination_name,
      forecast: {
        summary: current_w[:condition],
        temperature: "#{current_w[:temperature]} F"
      },
      salaries: salaries_array
    }

    ForecastSalary.new(new_hash)
  end

end