class Api::V1::Admin::DashboardController < ApplicationController
  before_action :authorize

  def show
    render json: {}, status: 200
  end

  def authorize
    if !Authorization.authorize_admin(request) || !Authorization.verify_signature(request)
     render json: {}, status: 404
   end
  end
end
