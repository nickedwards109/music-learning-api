class PasswordReset < ApplicationRecord
  attribute :uuid, :string, default: -> { SecureRandom.uuid }
  belongs_to :user
end
