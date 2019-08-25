require 'rails_helper'

RSpec.describe "Authorization", type: :request do
  it "allows access to the admin dashboard if the request contains a valid JSON web token indicating an admin role in the payload" do
    user = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    # Generate a valid JSON web token that indicates an admin role for testing purposes
    key = Rails.application.credentials.secret_key_base
    header = Base64.urlsafe_encode64("{\"alg\":\"HS256\"}")
    admin_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"exp\":#{Time.now.to_i}},\"role:admin\"")
    header_and_payload = header + "." + admin_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    admin_token = header + "." + admin_role_payload + "." + signature

    # If a user tries to access an admin dashboard with no token,
    # don't tell the user what happened and instead return a 404
    get "/api/v1/admin/dashboard"
    expect(response).to have_http_status(404)

    # If a user tries to access an admin dashboard with an invalid token,
    # don't tell the user what happened and instead return a 404
    get "/api/v1/admin/dashboard?token=1234"
    expect(response).to have_http_status(404)

    # If a user tries to access an admin dashboard with a valid token, return a 200
    get "/api/v1/admin/dashboard?token=#{admin_token}"
    expect(response).to have_http_status(200)
  end

  it "does not allow access to the admin dashboard if the request contains a JSON web token indicating an student role in the payload" do
    user = User.create(
                      role: :student,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    # Generate a valid JSON web token that indicates a student role for testing purposes
    key = Rails.application.credentials.secret_key_base
    header = Base64.urlsafe_encode64("{\"alg\":\"HS256\"}")
    student_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"exp\":#{Time.now.to_i}},\"role:student\"")
    header_and_payload = header + "." + student_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    student_token = header + "." + student_role_payload + "." + signature

    # If a student tries to access an admin dashboard, return a 404
    get "/api/v1/admin/dashboard?token=#{student_token}"
    expect(response).to have_http_status(404)
  end
end
