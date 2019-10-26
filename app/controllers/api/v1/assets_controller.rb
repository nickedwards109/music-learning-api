class Api::V1::AssetsController < ApplicationController
  before_action :authorize_teacher
  before_action :verify_signature

  def presigned_upload_url
    s3_data = S3_BUCKET.presigned_post(key: "uploads/#{SecureRandom.uuid}/${filename}", success_action_status: '201', acl: 'public-read')
    render json: { url: s3_data.url, fields: s3_data.fields }, status: '200'
  end

  private

  def authorize_teacher
    if !Authorization.authorize(request, :teacher)
     render json: {}, status: 404
    end
  end
end
