class User < ApplicationRecord
  has_secure_password
  validates :role, :first_name, :last_name, :email, :password_digest, presence: true
  enum role: [:admin, :teacher, :student]
  has_many :assignments
  has_many :lessons, through: :assignments
end
