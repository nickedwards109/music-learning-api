class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end

    def decode(token)
      JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
    end
  end
end
