class AuthController < ApplicationController
    skip_before_action :authorize_request, only: [ :login, :signup ]

    def signup
      user = User.new(user_params)
      if user.save
        token = JsonWebToken.encode(user_id: user.id)
        render json: { token: token, user: user }, status: :created
      else
        render json: { erros: user.errors.full_messages }, status: :unprocessable_entity
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
        params.permit(:name, :email, :password, :password_confirmation, :role)
    end
end
