class Api::V1::Admin::DashboardController < ApplicationController
  before_action :authorize

  def show
  end

  def authorize
    if Authorization.authorize(request) == true
      render json: {}, status: 200
    else
     render json: {}, status: 404
   end
  end
end
