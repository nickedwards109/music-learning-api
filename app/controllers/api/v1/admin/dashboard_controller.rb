class Api::V1::Admin::DashboardController < ApplicationController
  before_action :authorize

  def show
  end

  def authorize
    if Authorization.authorize_admin(request) == true && Authorization.verify_signature(request)
      render json: {}, status: 200
    else
     render json: {}, status: 404
   end
  end
end
