class Authorization
  class << self
    def authorize(request)
      if token = request.params[:token]
        if token.split('.').count == 3
          return false unless decoded_token = JsonWebToken.decode(token)
          header = token.split('.')[0]
          payload = token.split('.')[1]
          signature = token.split('.')[2]
          key = Rails.application.credentials.secret_key_base
          header_and_payload = header + "." + payload
          hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
          expected_signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
          return true if signature == expected_signature
        end
      else
        return false
      end
    end
  end
end
