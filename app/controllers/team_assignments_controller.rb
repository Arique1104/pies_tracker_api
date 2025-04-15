class TeamAssignmentsController < ApplicationController
  before_action :authorize_owner

  def create
    assignment = TeamAssignment.new(leader_id: params[:leader_id], individual_id: params[:individual_id])

    if assignment.save
      render json: assignment, status: :created
    else
      render json: { errors: assignment.errors.full_messages }, status: :unprocessable_entity
    end
  end

def destroy
  assignment = TeamAssignment.find(params[:id])
  if assignment.destroy
    head :no_content
  else
    render json: { error: "Failed to delete assignment" }, status: :unprocessable_entity
  end
end

  def find_by_pair
    assignment = TeamAssignment.find_by(leader_id: params[:leader_id], individual_id: params[:individual_id])

    if assignment
      render json: assignment
    else
      render json: { error: "Assignment not found" }, status: :not_found
    end
  end

  private

  def authorize_owner
    render json: { error: "Unauthorized" }, status: :unauthorized unless @current_user&.role == "owner"
  end
end
