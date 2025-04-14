class AssignmentInsightsController < ApplicationController
    before_action :authorize_owner

    def index
        leaders = User.where(role: :leader).map do |leader|
            {
                id: leader.id,
                name: leader.name,
                pies_averages: leader_average_pies(leader),
                assigned_individuals: leader_assigned_individuals(leader),
                open_slots: max_capacity - leader.team_assignments.count
            }
        end

        assigned_ids = TeamAssignment.pluck(individual)

        unassigned_individuals = User.where(role: :individual).where.not(id: assigned_ids).map do |individual|
            {
                id: individual.id,
                name: individual.name,
                pies_history: last_three_enties(individual),
                streak_score: submission_steak(individual),
                suggested_leaders: suggested_leader_matches(individual, leaders)
            }
        end

        render json: { leaders: leaders, unassigned_individuals: unassigned_individuals }
    end

    private

    def authorize_owner
        unless @current_user.role == "owner"
            render json: {error: "Unauthorized", status: :unathorized}
        end
    end

    def max_capacity
        5
    end

    def leader_average_pies(leader)
        entries = leader.pies_entries.last(5)
        return default_pies unless entries.present?

        %i[physical intellectual emotional spiritual].index_with do |k|
            (entries.map(&"#{k}_score".to_sym).compact.sum.to_f / entries.count).round(2)
        end   
    end
    

    def last_three_entries(user)
        user.pies_entries.order(checked_in_on: :desc).limit(3).map do |entry|
            {
                checked_in_on: entry.checked_in_on,
                physical: entry.physical_score,
                intellectual: entry.intellectual_score,
                emotional: entry.emotional_score,
                spiritual: entry.spiritual_score
            }
    
        end
    end

    def submission_steak(user)
        last_week = 6.days.ago.to_date..Date.today
        user.pies_entries.where(checked_in_on: last_week)
    end
    

    def default_pies
        {
            physical: 0,
            intellectual: 0,
            emotional: 0,
            spiritual: 0
        }
    end

    def suggested_leader_matches(individual, leader_data)
        recent = last_three_entries(individual)
        return [] unless recent.any?

        avg_needs = %i[physical intellectual emotional spiritual].index_with do |k|
            (recent.map {|entry| entry[k] }.compact.sum.to_f / recent.count).round(2)
        end

        leader_data.map do |leader|
            next if leader[:open_slots] <= 0
            alignment = %i[physical intellectual emotional spiritual].map do |k|
                {k: k, diff: (leader[:pies_averages][k] - avg_needs[k]).round(2) }
            end

            top_gap = alignment.max_by { |d| d[:diff].abs }
            {
                id: leader[:id],
                name: leader[:name],
                open_slots: leader[:open_slots],
                match_reason: "Leader reflects high #{top_gap[:k].to_s.capitalize} scores while Individual shows lower scores in that area"

            }
        end.compact.sort_by { |s| s[:open_slots] * -1 } # prioritize availability
    end
end
