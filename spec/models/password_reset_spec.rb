require 'rails_helper'

RSpec.describe 'PasswordReset', type: :model do
  # TODO decouple this test from the User implementation
  it 'belongs to a user and has a uuid attribute' do
    user = User.create(first_name: 'John',
                       last_name: 'Doe',
                       role: 'teacher',
                       email: 'john@example.com',
                       password: '9#gpB)S2',
                       password_confirmation: '9#gpB)S2')
    password_reset = PasswordReset.create(user_id: user.id)
    expect(password_reset).to be_valid
    expect(password_reset.uuid).not_to be_nil
    expect(password_reset.user_id).to eq(user.id)
  end
end
