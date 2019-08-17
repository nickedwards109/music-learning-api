class Authorization
  class << self
    def authorize(request)
      if token = request.params[:token]
        if valid_length(token)
          header, payload, claim_signature = get_parts(token)
          key = Rails.application.credentials.secret_key_base
          valid_signature = sign(header, payload, key)
          claim_signature == valid_signature
        end
      else
        return false
      end
    end

    def valid_length(token)
      token.split('.').count == 3
    end

    def get_parts(token)
      [ header = token.split('.')[0],
        payload = token.split('.')[1],
        signature = token.split('.')[2] ]
    end

    def sign(header, payload, key)
      concatenated_header_payload = header + "." + payload
      hashed_header_payload = hash(concatenated_header_payload, key)
      Base64.urlsafe_encode64(hashed_header_payload).gsub("=", "")
    end

    def hash(concatenated_header_payload, key)
      OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, concatenated_header_payload)
    end
  end
end
