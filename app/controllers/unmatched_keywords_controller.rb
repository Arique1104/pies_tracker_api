class UnmatchedKeywordsController < ApplicationController
    before_action :authorize_owner

    def index
        keywords = UnmatchedKeyword.order(count: :desc)
        render json: keywords
    end
    private

    def authorize_owner
        unless @current_user.role === "owner"
            render json: { error: "Unathorized" }, status: :unathorized
        end
    end
end