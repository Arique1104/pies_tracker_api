class User < ApplicationRecord
  include ActiveRecord::Enum
  has_secure_password

  has_many :pies_entries, dependent: :destroy
  has_many :team_assignments, foreign_key: :leader_id, class_name: "TeamAssignment"
  has_many :assigned_users, through: :team_assignments, source: :individual

  enum :role, { individual: 0, leader: 1, owner: 2 }

  validates :email, presence: true, uniqueness: true
end
