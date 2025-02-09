class ApplicationController < ActionController::API
  before_action :authenticate_user

  def authenticate_user
    payload = JWT.decode(request.headers["Authorization"].split(" ").last, ENV["ACCESS_TOKEN_SECRET"], true, { algorithm: "HS256" })
    @current_user = User.find_by(id: payload[0]["user_id"])
  rescue JWT::ExpiredSignature
    render_error("Access token expired", 401)
  rescue JWT::DecodeError
    render_error("Invalid access token", 401)
  end

  private
  def render_error(errors, status)
    render json: {
      status: status,
      message: errors.is_a?(Array) ? errors.join(", ") : errors
    }, status: status
  end
end
