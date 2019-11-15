require 'rails_helper'

RSpec.describe 'Resetting a password', type: :request do
  let!(:user) {User.create(first_name: 'John',
                           last_name: 'Doe',
                           role: 'teacher',
                           email: 'john@example.com',
                           password: '9#gpB)S2',
                           password_confirmation: '9#gpB)S2'
  )}

  it 'enables a user to initiate the password reset process' do
    initial_password_reset_count = PasswordReset.all.count
    initial_emails_count = ActionMailer::Base.deliveries.count

    post '/api/v1/initiate_password_reset', params: {
      user: {
        email: 'john@example.com'
      }
    }

    final_password_reset_count = PasswordReset.all.count
    expect(final_password_reset_count).to eq(initial_password_reset_count + 1)

    final_emails_count = ActionMailer::Base.deliveries.count
    expect(final_emails_count).to eq(initial_emails_count + 1)

    password_reset = PasswordReset.last
    expect(password_reset.uuid).not_to be_nil
    expect(password_reset.user).to eq(user)
    expect(ActionMailer::Base.deliveries.last.body.raw_source).to include(password_reset.uuid)

    expect(response).to have_http_status(204)
  end

  it 'does not start the password reset process if the provided email does not belong to a user' do
    initial_password_reset_count = PasswordReset.all.count
    initial_emails_count = ActionMailer::Base.deliveries.count

    post '/api/v1/initiate_password_reset', params: {
      user: {
        email: 'doesnotexist@example.com'
      }
    }

    final_password_reset_count = PasswordReset.all.count
    expect(final_password_reset_count).to eq(initial_password_reset_count)

    final_emails_count = ActionMailer::Base.deliveries.count
    expect(final_emails_count).to eq(initial_emails_count)

    expect(response).to have_http_status(404)
  end
end
