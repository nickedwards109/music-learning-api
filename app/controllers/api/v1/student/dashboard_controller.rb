class Api::V1::Student::DashboardController < ApplicationController
  before_action :authorize_student
  before_action :verify_signature

  def show
    token = dashboard_params[:token]
    id = get_id(token)
    user = User.find(id)
    first_name = user.first_name
    render json: {firstName: first_name}, status: 200
  end

  def authorize_student
    if !Authorization.authorize(request, :student)
     render json: {}, status: 404
   end
  end

  private

  def dashboard_params
    params.permit(:token)
  end
end
