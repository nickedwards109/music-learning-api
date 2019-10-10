require 'rails_helper'

RSpec.describe "Teacher Dashboard", type: :request do
  it "responds with the teacher's name" do
    user = User.create(
                      role: :teacher,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "teacher@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    # Generate a valid JSON web token that indicates a teacher role for testing purposes
    key = Rails.application.credentials.secret_key_base
    header = Base64.urlsafe_encode64("{\"alg\":\"HS256\"}")
    teacher_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"role\":\"teacher\"}")
    header_and_payload = header + "." + teacher_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    teacher_token = header + "." + teacher_role_payload + "." + signature

    get "/api/v1/teacher/dashboard", params: {}, headers: { TOKEN: teacher_token }

    parsed_response = JSON.parse(response.body)

    first_name = parsed_response["firstName"]
    expect(first_name).to eq(user.first_name)
  end
end
