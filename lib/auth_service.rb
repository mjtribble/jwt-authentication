require "jwt"

module AuthService
  class << self
    RSA_PRIVATE = OpenSSL::PKey::RSA.generate 2048
    RSA_PUBLIC = RSA_PRIVATE.public_key
    ACCESS_EXPIRATION = 30.minutes.from_now
    REFRESH_EXPIRATION = RefreshToken::EXPIRATION
    ALGO = "RS256"

    def encode(payload)
      JWT.encode(payload, RSA_PRIVATE, ALGO)
    end

    def decode(token)
      JWT.decode(token, RSA_PUBLIC, true, {algorithm: ALGO}).first
    rescue JWT::ExpiredSignature
    rescue JWT::DecodeError
    end

    def generate_tokens_for(user, access_exp: ACCESS_EXPIRATION, refresh_exp: REFRESH_EXPIRATION)
      {
        access_token: generate_access_token(user, expiration: access_exp),
        refresh_token: generate_refresh_token(user, expiration: refresh_exp)
      }
    end

    # ArgumentError: wrong number of arguments (given 2, expected 1)
    # lib/auth_service.rb:30:in `generate_access_token'
    def generate_access_token(user, expiration: ACCESS_EXPIRATION)
      encode(
        {
          user_id: user.id,
          iat: Time.now.utc.to_i,
          jti: SecureRandom.uuid,
          exp: expiration.to_i
        }
      )
    end

    def generate_refresh_token(user, expiration: REFRESH_EXPIRATION)
      user.refresh_tokens.active.update_all(replaced_at: Time.current)
      user.refresh_tokens.create!(expires_at: expiration).secret
    end
  end
end
