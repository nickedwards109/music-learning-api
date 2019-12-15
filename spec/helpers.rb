module SpecHelper
  class << self
    # Input: a User instance
    # Output: a JSON web token identifying the user as an authenticated user
    def generate_token(user)
      key = Rails.application.credentials.secret_key_base
      header = Base64.urlsafe_encode64("{\"alg\":\"HS256\"}")
      payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"role\":\"#{user.role}\"}")
      header_and_payload = header + "." + payload
      hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
      signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
      header + "." + payload + "." + signature
    end
  end
end
