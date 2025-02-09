class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    @user.status = "active"

    if @user.save!
      render json: {
        user: UserSerializer.new(@user)
      }, status: :created
    else
      render_error @user.errors.full_messages, :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render_error e.record.errors.full_messages, :unprocessable_entity
  end

private

  def user_params
    params.require(:user).permit(:email, :name, :phone, :password, :password_confirmation)
  end
end
