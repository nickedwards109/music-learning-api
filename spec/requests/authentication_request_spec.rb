require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  it "responds with a 401 Unauthorized and no JSON web token when a client POSTS with invalid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/api/v1/sessions?session[email]=admin%40example.com&session[password]=1234'
    expect(response).to have_http_status(401)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).not_to have_key("token")
  end

  it "responds with a 200 OK and a JSON web token when a client POSTS with valid credentials" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    post '/api/v1/sessions?session[email]=admin%40example.com&session[password]=85kseOlqqp%21v1%40a7'
    expect(response).to have_http_status(200)
    parsed_response = JSON.parse(response.body)
    expect(parsed_response).to have_key("token")
    expect(parsed_response["token"].split('.').count).to eq(3)
  end
end
