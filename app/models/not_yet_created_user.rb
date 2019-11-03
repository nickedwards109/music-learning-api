class NotYetCreatedUser < ApplicationRecord
  attribute :uuid, :string, default: -> { SecureRandom.uuid }
  enum role: [:teacher, :student]
  before_save :url_decode_email

  def url_decode_email
    self.email = CGI.unescape(self.email)
  end
end
