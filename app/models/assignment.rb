class Assignment < ApplicationRecord
  validates :lesson_id, :user_id, presence: true
  belongs_to :lesson
  belongs_to :user
end
