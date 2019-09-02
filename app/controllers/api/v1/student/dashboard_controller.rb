class Api::V1::Student::DashboardController < ApplicationController
  before_action :authorize

  def show
    token = dashboard_params[:token]
    id = get_id(token)
    user = User.find(id)
    first_name = user.first_name
    render json: {firstName: first_name}, status: 200
  end

  def authorize
    if !Authorization.authorize(request, :student) || !Authorization.verify_signature(request)
     render json: {}, status: 404
   end
  end

  private

  def dashboard_params
    params.permit(:token)
  end
end
