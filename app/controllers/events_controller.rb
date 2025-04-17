class EventsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_owner_or_leader, only: [ :create, :update ]

  def index
    render json: Event.includes(:hosts).order(date: :asc), status: :ok
  end

  def create
    event = Event.new(event_params.merge(created_by_id: @current_user.id))

    if event.save
      # Add all provided host_ids
      event.hosts << User.where(id: params[:host_ids]) if params[:host_ids]
      render json: event, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    event = Event.find(params[:id])

    unless event.hosts.include?(@current_user)
      return render json: { error: "Unauthorized" }, status: :unauthorized
    end

    if event.update(event_params)
      event.hosts = User.where(id: params[:host_ids]) if params[:host_ids]
      render json: event, status: :ok
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    event = Event.includes(:hosts).find(params[:id])
    render json: event, status: :ok
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :date, :location)
  end
end
