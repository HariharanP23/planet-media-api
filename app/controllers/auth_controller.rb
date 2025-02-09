class AuthController < ApplicationController
  skip_before_action :authenticate_user

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])

      render json: {
        user: UserSerializer.new(@user),
        access_token: generate_access_token,
        refresh_token: generate_refresh_token,
        expires_in: 15.minutes.from_now.to_i
      }
    else
      render_error("Invalid email or password", 401)
    end
  end

  private

  def generate_access_token
    JWT.encode({ user_id: @user.id, exp: Time.now.to_i + (30 * 60) }, ENV["ACCESS_TOKEN_SECRET"], "HS256")
  end

  def generate_refresh_token
    JWT.encode({ user_id: @user.id }, ENV["REFRESH_TOKEN_SECRET"], "HS256")
  end
end
