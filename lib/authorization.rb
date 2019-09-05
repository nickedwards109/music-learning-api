class Authorization
  class << self
    def verify_signature(request)
      if token = request.params[:token]
        if JsonWebToken.decode(token)
          return true
        end
      else
        return false
      end
    end

    def authorize(request, role)
      if token = request.params[:token]
        JsonWebToken.decode(token)[0]["role"] == role.to_s
      else
        return false
      end
    end
  end
end
