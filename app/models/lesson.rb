class Lesson < ApplicationRecord
  has_many :assets
  validates :title, presence: true
  accepts_nested_attributes_for :assets
  has_many :assignments
  has_many :users, through: :assignments

  def students
    self.users
  end
end
