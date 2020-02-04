require 'rails_helper'

RSpec.describe 'Setting a password', type: :request do
  let!(:not_yet_created_user) { NotYetCreatedUser.create({
    first_name: "John",
    last_name: "Doe",
    email: "johndoe%40example.com",
    role: "teacher"
    }) }

  it "enables a new user to set their password and create their account, and automatically logs them in" do
    user_count_before = User.all.count
    not_yet_created_user_count_before = NotYetCreatedUser.all.count
    uuid = not_yet_created_user.uuid
    post '/api/v1/set-password', params: {
      user: {
        password: "85kseOlqqp!v1@a7",
        password_confirmation: "85kseOlqqp!v1@a7",
        uuid: uuid
      }
    }
    user_count_after = User.all.count
    not_yet_created_user_count_after = NotYetCreatedUser.all.count
    expect(user_count_after).to eq(user_count_before + 1)
    expect(not_yet_created_user_count_after).to eq(not_yet_created_user_count_before - 1)
    expect(response).to have_http_status(204)
  end

  it "responds with a 404 to a set password request with an invalid UUID" do
    user_count_before = User.all.count
    not_yet_created_user_count_before = NotYetCreatedUser.all.count
    post '/api/v1/set-password', params: {
      user: {
        password: "85kseOlqqp!v1@a7",
        password_confirmation: "85kseOlqqp!v1@a7",
        uuid: "asdf"
      }
    }
    user_count_after = User.all.count
    not_yet_created_user_count_after = NotYetCreatedUser.all.count
    expect(user_count_after).to eq(user_count_before)
    expect(not_yet_created_user_count_before).to eq(not_yet_created_user_count_after)
    expect(response).to have_http_status(404)
  end
end
