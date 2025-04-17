class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      # TODO: Replace with real mailer
      puts "Send reset link to user: #{reset_url(user.reset_password_token)}"
    end
    render json: { message: "If that email exists, a reset link has been sent." }
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])
    if @user&.password_reset_token_valid?
      render json: { valid: true }
    else
      render json: { error: "Invalid or expired token." }, status: :unauthorized
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])
    if @user&.password_reset_token_valid?
      @user.update!(password: params[:password])
      @user.clear_password_reset_token!
      render json: { message: "Password has been reset." }
    else
      render json: { error: "Invalid or expired token." }, status: :unauthorized
    end
  end

  private

  def reset_url(token)
    "#{request.base_url}/reset_password?token=#{token}"
  end
end
