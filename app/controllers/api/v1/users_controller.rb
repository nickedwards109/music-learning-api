class Api::V1::UsersController < ApplicationController
  before_action :authorize_admin, except: [:set_password]
  before_action :verify_signature, except: [:set_password]

  def send_new_user_email
    UserMailer.with(params: user_params).set_password_email.deliver_now
  end

  def set_password
    if not_yet_created_user = NotYetCreatedUser.find_by(uuid: user_params[:uuid])
      user_attributes = {
        first_name: not_yet_created_user.first_name,
        last_name: not_yet_created_user.last_name,
        email: not_yet_created_user.email,
        role: not_yet_created_user.role,
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
      }
      if user = User.create(user_attributes)
        not_yet_created_user.destroy
        render json: {}, status: 204
      else
        render json: {}, status: 404
      end
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
    params.require(:user).permit(:role, :first_name, :last_name, :email, :password, :password_confirmation, :uuid)
  end
end
