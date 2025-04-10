class User < ApplicationRecord
  has_secure_password

  has_many :pies_entries
  has_many :team_assignments, foreign_key: :leader_id, class_name: "TeamAssignment"
  has_many :assigned_users, through: :team_assignments, source: :individual

  validates :role, inclusion: { in: %w[individual leader owner] }
end