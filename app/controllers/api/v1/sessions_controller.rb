class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user.authenticate(session_params[:password])
      token = JsonWebToken.encode({id: user.id})
      render json: {token: token}, status: 200
    else
      render json: {}, status: 404
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
