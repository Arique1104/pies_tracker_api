class LeaderTeamInsightsController < ApplicationController
  before_action :authorize_leader

  def index
    team_members = @current_user.assigned_users

    pies_averages = average_team_pies(team_members)
    member_data = team_members.map do |user|
      {
        id: user.id,
        name: user.name,
        streak_score: submission_streak(user)
      }
    end

    render json: {
      team_average_pies: pies_averages,
      team_members: member_data
    }
  end

  private

  def authorize_leader
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user&.role == 'leader'
  end

  def average_team_pies(users)
    return default_pies if users.empty?

    recent_entries = PiesEntry.where(user_id: users.map(&:id))
                              .where(checked_in_on: 7.days.ago.to_date..Date.today)

    return default_pies if recent_entries.empty?

    %i[physical intellectual emotional spiritual].index_with do |k|
      values = recent_entries.map(&k).compact
      values.any? ? (values.sum.to_f / values.size).round(2) : 0
    end
  end

  def submission_streak(user)
    last_week = 6.days.ago.to_date..Date.today
    user.pies_entries.where(checked_in_on: last_week).count
  end

  def default_pies
    { physical: 0, intellectual: 0, emotional: 0, spiritual: 0 }
  end
end
