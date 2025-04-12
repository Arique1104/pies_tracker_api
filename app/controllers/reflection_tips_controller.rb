class ReflectionTipsController < ApplicationController
  before_action :authorize_owner

  def index
    tips = ReflectionTip.order(:category, :word)
    render json: tips
  end

  def create
    tip = ReflectionTip.new(tip_params)
    if tip.save
      render json: tip, status: :created
    else
      render json: { errors: tip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    tip = ReflectionTip.find(params[:id])
    if tip.update(tip_params)
      render json: tip
    else
      render json: { errors: tip.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    tip = ReflectionTip.find(params[:id])
    tip.destroy
    head :no_content
  end

  private

  def tip_params
    params.require(:reflection_tip).permit(:word, :category, :tip)
  end

  def authorize_owner
    unless @current_user&.role == "owner"
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
