require 'jwt'
class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  
  def self.decode(token)
    JWT.decode(token, SECRET_KEY)[0]
  rescue JWT::DecodeError => e
    Rails.logger.error("JWT Decode failed: #{e.message}")
    nil
  end
  # def self.decode(token)
  #   decoded = JWT.decode(token, SECRET_KEY)[0]
  #   HashWithIndifferentAccess.new(decoded)
  # rescue JWT::DecodeError
  #   Rails.logger.error("JWT Decode failed: #{e.message}")
  #   nil
  # end
end