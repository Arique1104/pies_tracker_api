class ReflectionTipsController < ApplicationController
  before_action :authorize_owner, except: [ :index ]
  before_action :authorize_owner_or_leader, only: [ :index ]
  before_action :authorize_request, only: [ :pies_tip_map ]

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

  def pies_tip_map
    if tips.empty?
      render json: {}
    else
      grouped = tips.group_by(&:category)
                    .transform_values { |group| group.map(&:word).uniq }

      render json: grouped
    end
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
