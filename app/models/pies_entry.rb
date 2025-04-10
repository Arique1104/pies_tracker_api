class PiesEntry < ApplicationRecord
  belongs_to :user

  validates :checked_in_on, presence: true
  
  validates :physical, :intellectual, :emotional, :spiritual, presence: true
  
  validates :physical_description, :intellectual_description, :emotional_description, :spiritual_description, length: { maximum: 2000 }
end
