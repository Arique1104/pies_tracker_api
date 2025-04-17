class DismissedKeywordsController < ApplicationController
  before_action :authorize_owner

  def create
    word = params[:word].to_s.downcase.strip
    dismissed = DismissedKeyword.find_or_create_by!(word: word)
    render json: dismissed, status: :created
  end

  private

  def authorize_owner
    unless @current_user&.role == "owner"
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
