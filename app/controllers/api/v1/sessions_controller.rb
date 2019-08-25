class Api::V1::SessionsController < ApplicationController
  def create
    if user = User.find_by(email: session_params[:email])
      if user.authenticate(session_params[:password])
        token = JsonWebToken.encode({id: user.id, role: user.role})
        render json: {token: token}, status: 200
      else
        render json: {}, status: 404
      end
    else
      render json: {}, status: 404
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
