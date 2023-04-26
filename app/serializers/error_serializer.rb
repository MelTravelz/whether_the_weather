class ErrorSerializer
  def initialize(status, errors)
    @status = status
    @errors = errors
  end

  def invalid_request
    {
      errors: [
        {
          "status": @status,
          "title": 'Invalid Request',
          "detail": @errors
        }
      ]
    }
  end
end