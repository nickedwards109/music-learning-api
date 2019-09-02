class ApplicationController < ActionController::API
  def get_id(token)
    encoded_payload = token.split(".")[1]
    decoded_payload = Base64.urlsafe_decode64(encoded_payload)
    payload = JSON.parse(decoded_payload)
    id = payload["id"]
  end
end
