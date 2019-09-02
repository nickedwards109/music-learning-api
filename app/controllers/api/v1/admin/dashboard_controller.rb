class Api::V1::Admin::DashboardController < ApplicationController
  before_action :authorize_admin
  before_action :verify_signature

  def show
    token = dashboard_params[:token]
    id = get_id(token)
    user = User.find(id)
    first_name = user.first_name
    render json: {firstName: first_name}, status: 200
  end

  def authorize_admin
    if !Authorization.authorize(request, :admin)
     render json: {}, status: 404
   end
  end

  private

  def dashboard_params
    params.permit(:token)
  end
end
