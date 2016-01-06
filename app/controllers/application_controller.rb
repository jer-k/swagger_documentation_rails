class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    @error = "The #{parameter_missing_exception.param} parameter is missing"
    render 'shared/error', status: :bad_request
  end

  rescue_from(ArgumentError) do |argument_error|
    @error = argument_error.message
    render 'shared/error', status: :bad_request
  end
end
