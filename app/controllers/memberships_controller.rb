class MembershipsController < ApplicationController
  before_action :authorize_request
  before_action :authorize_manager_of_org, only: [:update]

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

  def update
    membership = Membership.find(params[:id])
    
    if membership.update(role: params[:role])
      render json: { message: "Role updated", role: membership.role }
    else
      render json: { error: membership.errors.full_messages }, status: :unprocessable_entity
    end
  end

    def index
        org_id = params[:organization_id]
        unless @current_user.role_in(Organization.find(org_id)) == 'manager'
            return render json: { error: 'Unauthorized' }, status: :unauthorized
        end

        memberships = Membership.includes(:user).where(organization_id: org_id)
        render json: memberships, include: [:user]
    end

    def invite
  org = Organization.find(params[:organization_id])
  role = params[:role] || 'individual'

  unless @current_user.role_in(org) == 'manager'
    return render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  # Find or create the user
  user = User.find_by(email: params[:email])
  if user.nil?
    # Create a user with a temp password (they'll reset it)
    user = User.create!(
      name: params[:name] || params[:email].split('@').first,
      email: params[:email],
      password: SecureRandom.hex(10)
    )

    # You could trigger a password reset email here
  end

  # Create membership unless it already exists
  membership = Membership.find_or_initialize_by(user: user, organization: org)
  membership.role = role
  membership.save!

  render json: {
    message: "User invited",
    membership: {
      id: membership.id,
      role: membership.role,
      user: {
        id: user.id,
        name: user.name,
        email: user.email
      }
    }
  }
end

  private

  def authorize_manager_of_org
    membership = Membership.find(params[:id])
    org = membership.organization

    unless @current_user.role_in(org) == 'manager'
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
