class UnmatchedKeywordsController < ApplicationController
    before_action :authorize_owner

    def index
        keywords = UnmatchedKeyword.order(count: :desc)
        render json: keywords
    end

    def destroy
    keyword = UnmatchedKeyword.find(params[:id])
    word = keyword.word.downcase.strip

    if ReflectionTip.exists?(word: word)
        # Tip already created for this word — just clean it up
        keyword.destroy!
        render json: { message: "Unmatched keyword removed (tip exists)" }, status: :ok
    else
        # No tip exists — treat this as a dismissal
        DismissedKeyword.find_or_create_by!(word: word)
        keyword.destroy!
        render json: { message: "Unmatched keyword dismissed and removed" }, status: :ok
    end
    rescue ActiveRecord::RecordNotFound
    render json: { error: "Unmatched keyword not found" }, status: :not_found
    end

    private

    def authorize_owner
        unless @current_user.role === "owner"
            render json: { error: "Unathorized" }, status: :unathorized
        end
    end
end
