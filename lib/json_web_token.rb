class JsonWebToken
  class << self
    def encode(payload)
      JWT.encode(payload, Rails.application.credentials.secret_key_base, 'HS256')
    end
  end
end
