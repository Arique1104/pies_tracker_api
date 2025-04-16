class UnmatchedKeywordsController < ApplicationController
    before_action :authorize_owner

    def index
        keywords = UnmatchedKeyword.order(count: :desc)
        render json: keywords
    end

    def destroy
        keyword = UnmatchedKeyword.find(params[:id])
        keyword.destroy
        render json: { message: "Unmatched keyword removed" }, status: :ok
    rescue ActiveRecord::RecordNotFound
        render json: { error: "Keyword not found" }, status: :not_found
    end
    private

    def authorize_owner
        unless @current_user.role === "owner"
            render json: { error: "Unathorized" }, status: :unathorized
        end
    end
end
