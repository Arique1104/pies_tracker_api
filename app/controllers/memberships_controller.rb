class MembershipsController < ApplicationController
  before_action :authorize_request

  def me
    org_id = params[:organization_id]

    if org_id.blank?
      return render json: { error: 'organization_id is required' }, status: :bad_request
    end

    membership = Membership.find_by(user_id: @current_user.id, organization_id: org_id)

    if membership
      render json: { role: membership.role, organization_id: org_id }
    else
      render json: { error: 'Membership not found' }, status: :not_found
    end
  end
end
