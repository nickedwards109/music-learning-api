class ApplicationController < ActionController::API
  def get_id(token)
    encoded_payload = token.split(".")[1]
    decoded_payload = Base64.urlsafe_decode64(encoded_payload)
    payload = JSON.parse(decoded_payload)
    id = payload["id"]
  end

  def verify_signature
    if !Authorization.verify_signature(request)
     render json: {}, status: 404
   end
  end

  def authorize_admin
    if !Authorization.authorize(request, :admin)
     render json: {}, status: 404
    end
  end

  def authorize_teacher
    if !Authorization.authorize(request, :teacher)
     render json: {}, status: 404
    end
  end

  def authorize_student
    if !Authorization.authorize(request, :student)
     render json: {}, status: 404
   end
  end
end
