require 'rails_helper'

RSpec.describe "Admin Dashboard", type: :request do
  it "responds with the admin's name" do
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
    admin_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"role\":\"admin\",\"exp\":#{Time.now.to_i}}")
    header_and_payload = header + "." + admin_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    admin_token = header + "." + admin_role_payload + "." + signature

    get "/api/v1/admin/dashboard?token=#{admin_token}"
    parsed_response = JSON.parse(response.body)
    first_name = parsed_response["firstName"]
    expect(first_name).to eq(user.first_name)
  end
end
