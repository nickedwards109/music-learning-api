class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user.authenticate(session_params[:password])
      render json: {}, status: 200
    else
      render json: {}, status: 401
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
