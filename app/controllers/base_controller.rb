class BaseController < ActionController::Base
  protect_from_forgery with: :null_session

  BAD_REQUEST_STATUS_CODE = 400
  VALIDATION_ERROR_CODE = 422

  rescue_from ArgumentError, with: :argument_out_of_range
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :no_route_matches

  private

  def record_not_found
    render status: 404, json: {error: {
      message: "Not found",
    }}
  end

  def no_route_matches(exception)
    render status: 404, json: {error: {
      messages: [exception.message],
      fields: []
    }}
  end

  def argument_out_of_range(exception)
    render status: 400, json: {error: {
      messages: [exception.message]
    }}
  end

  def record_invalid(exception)
    record = exception.record
    messages = record.errors.full_messages

    render status: 422, json: {error: {
      messages: messages
    }}
  end
end
