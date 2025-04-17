
class PiesEntry < ApplicationRecord
  belongs_to :user

  validates :checked_in_on, presence: true
  validates :physical, :intellectual, :emotional, :spiritual, presence: true

  after_create :process_reflection_keywords

  private

  def process_reflection_keywords
    ReflectionAnalyzer.new(self).process_keywords
  end
end
