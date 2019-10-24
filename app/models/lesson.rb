class Lesson < ApplicationRecord
  has_many :assets
  validates :title, presence: true
  accepts_nested_attributes_for :assets
end
