class Api::V1::UsersController < ApplicationController
  before_action :authorize_admin
  before_action :verify_signature

  def create
    if user = User.create(user_params)
      role = user.role
      users_response = User.where(role: role).map { |user|
        user.to_json(only: [:first_name, :last_name, :email, :role])
      }
      render json: { users: users_response }, status: 200
    else
      render json: {}, status: 404
    end
  end

  private

  def authorize_admin
    if !Authorization.authorize(request, :admin)
     render json: {}, status: 404
    end
  end

  def user_params
    params.require(:user).permit(:role, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
