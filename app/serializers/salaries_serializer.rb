class SalariesSerializer 
  include JSONAPI::Serializer
  attributes :destination, :forecast, :salaries
end