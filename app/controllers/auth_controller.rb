class AuthController < ApplicationController
    skip_before_action :authorize_request, only: [ :login, :signup ]

    def signup
      requested_role = params[:role]
      allowed_roles = User.roles.keys
      role = allowed_roles.include?(requested_role) ? requested_role : 'individual'

      user = User.new(user_params.merge(role: role))
      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user }, status: :created
      else
        puts "Signup error: #{user.errors.full_messages}"
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def login
        user = User.find_by(email: params[:email])
        if user.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render json: { token: token, user: user }
        else
            render json: { errors: [ "Invalid email or password" ] }, status: :unathorized
        end
    end

    private
    def user_params
        params.permit(:name, :email, :password, :password_confirmation)
    end
end
