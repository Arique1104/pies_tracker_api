class Event < ApplicationRecord
    belongs_to :creator, class_name: "User", foreign_key: "created_by_id"
    has_many :event_hosts
  has_many :hosts, through: :event_hosts, source: :user

  validates :title, :date, presence: true
end
