class AuthController < ApplicationController
    skip_before_action :authorize_request, only: [ :login, :signup ]

  def signup
    params.delete(:auth)
    user = User.new(signup_params)
    if user.save
      token = encode_token({ user_id: user.id })
      render json: { user: user, token: token }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

def update
  user = User.find_by(reset_password_token: params[:token])

  if user&.password_reset_token_valid?
    user.update!(password: params[:password])
    user.clear_password_reset_token!

    token = encode_token({ user_id: user.id }) # <- your existing JWT/session method
    render json: { token: token, user: user }, status: :ok
  else
    render json: { error: "Invalid or expired token." }, status: :unauthorized
  end
end

    def login
      credentials = params[:auth] || params # support both formats
      user = User.find_by(email: credentials[:email])

      if user&.authenticate(credentials[:password])
        token = encode_token({ user_id: user.id })
        render json: { token: token, user: user }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation)
    end

      def signup_params
        params.permit(:name, :email, :password, :password_confirmation)
      end 
end
