class ApplicationController < ActionController::API
  private
  def render_error(errors, status)
    render json: {
      status: status,
      message: errors.is_a?(Array) ? errors.join(", ") : errors
    }, status: status
  end
end
