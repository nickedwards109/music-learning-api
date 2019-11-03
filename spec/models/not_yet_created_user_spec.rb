require 'rails_helper'

RSpec.describe NotYetCreatedUser, type: :model do
  it "has a first_name, last_name, email, role, and a UUID which is set by default" do
    user_attributes = {first_name: "John", last_name: "Doe", email: "johndoe@example.com", role: "teacher"}
    notYetCreatedUser = NotYetCreatedUser.create(user_attributes)
    expect(notYetCreatedUser).to be_valid
    expect(notYetCreatedUser.uuid).not_to be_nil
  end
end
