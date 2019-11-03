class Api::V1::UsersController < ApplicationController
  before_action :authorize_admin
  before_action :verify_signature

  def send_new_user_email
    UserMailer.with(params: user_params).set_password_email.deliver_now
  end

  private

  def authorize_admin
    if !Authorization.authorize(request, :admin)
     render json: {}, status: 404
    end
  end

  def user_params
    params.require(:user).permit(:role, :first_name, :last_name, :email)
  end
end
