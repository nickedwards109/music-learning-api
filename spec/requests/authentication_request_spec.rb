require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  it "responds with a 401 Unauthorized when a client POSTS with invalid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/sessions?email=admin%40example.com&password=1234'
    expect(response).to have_http_status(401)
  end

  it "responds with a 200 OK when a client POSTS with valid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/sessions?email=admin%40example.com&password=85kseOlqqp%21v1%40a7'
    expect(response).to have_http_status(200)
  end
end
