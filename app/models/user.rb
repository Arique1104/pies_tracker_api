class User < ApplicationRecord
  include ActiveRecord::Enum
  has_secure_password

  has_many :pies_entries, dependent: :destroy
  has_many :team_assignments, foreign_key: :leader_id, class_name: "TeamAssignment"
  has_many :assigned_users, through: :team_assignments, source: :individual

  enum :role, { individual: 0, leader: 1, owner: 2 }

  validates :email, presence: true, uniqueness: true

  has_many :created_events, class_name: "Event", foreign_key: "created_by_id"
  has_many :event_hosts
  has_many :hosted_events, through: :event_hosts, source: :event

  def generate_password_reset_token!
    self.reset_password_token = SecureRandom.urlsafe_base64(32)
    self.reset_password_sent_at = Time.current
    save!
  end

  def password_reset_token_valid?
    reset_password_sent_at > 2.hours.ago
  end

  def clear_password_reset_token!
    update!(reset_password_token: nil, reset_password_sent_at: nil)
  end
end
