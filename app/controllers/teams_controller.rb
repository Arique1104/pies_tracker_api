class TeamsController < ApplicationController
  before_action :authorize_owner

  def index
    leaders = User.where(role: :leader).map do |leader|
      {
        id: leader.id,
        name: leader.name,
        pies_averages: leader_average_pies(leader),
        open_slots: open_slot_count(leader),
        assigned_individuals: leader_assigned_individuals(leader)
      }
    end

    render json: leaders
  end

  private

  def authorize_owner
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user&.role == 'owner'
  end

  def leader_average_pies(leader)
    entries = leader.pies_entries.last(5)
    return default_pies unless entries.present?

    %i[physical intellectual emotional spiritual].index_with do |k|
      (entries.map(&k).compact.sum.to_f / entries.count).round(2)
    end
  end

  def open_slot_count(leader)
    5 - TeamAssignment.where(leader_id: leader.id).count
  end

  def leader_assigned_individuals(leader)
    leader.team_assignments.includes(:individual).map do |assignment|
      ind = assignment.individual
      {
        id: ind.id,
        name: ind.name,
        streak_score: submission_streak(ind)
      }
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
