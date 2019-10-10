class Api::V1::Teacher::DashboardController < ApplicationController
  before_action :authorize_teacher
  before_action :verify_signature

  def show
    token = request.headers["TOKEN"]
    id = get_id(token)
    user = User.find(id)
    first_name = user.first_name
    render json: {firstName: first_name}, status: 200
  end

  private

  def authorize_teacher
    if !Authorization.authorize(request, :teacher)
     render json: {}, status: 404
   end
  end
end
