class PiesEntry < ApplicationRecord
  belongs_to :user

  validates :checked_in_on, presence: true
  validates :physical, :intellectual, :emotional, :spiritual, presence: true
end
