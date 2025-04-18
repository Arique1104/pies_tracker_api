class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_owner_or_leader
    unless [ "owner", "leader" ].include?(@current_user&.role)
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  def authorize_request
    header = request.headers["Authorization"]
    puts "🪵 Raw header: #{request.headers['Authorization']}"
    header = header.split.last if header
    decoded = JsonWebToken.decode(header)
    puts "🧩 Decoded: #{decoded.inspect}" # after decoding
    @current_user = User.find(decoded[:user_id]) if decoded
    puts "👤 Current user: #{@current_user&.email}"
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ "Invalid token" ] }, status: :unauthorized
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.credentials.jwt_secret)
  end
end
