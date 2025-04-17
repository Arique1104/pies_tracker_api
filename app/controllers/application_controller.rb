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
    header = header.split.last if header
    decoded = JsonWebToken.decode(header)
    @current_user = User.find(decoded[:user_id]) if decoded
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ "Invalid token" ] }, status: :unauthorized
  end

  def encode_token(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

end
