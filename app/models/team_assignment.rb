class TeamAssignment < ApplicationRecord
  belongs_to :leader, class_name: 'User'
  belongs_to :individual, class_name: 'User'
end
