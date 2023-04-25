class RoadtripFacade
  attr_reader :mapquest_service #,
              # :weather_service

  def initialize
    @mapquest_service = MapQuestService.new
    # @weather_service = WeatherService.new
  end
end