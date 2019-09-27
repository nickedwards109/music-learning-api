require 'rails_helper'

RSpec.describe "Teachers", type: :request do
  it "does not create a teacher when the request does not include a token" do
    initial_teachers_count = User.where(role: "teacher").count
    post '/api/v1/users?user[first_name]=John&user[last_name]=Doe&user[email]=john%40example.com&user[password]=85kseOlqqp!v1@a7&user[password_confirmation]=85kseOlqqp!v1@a7'
    afterward_teachers_count = User.where(role: "teacher").count
    expect(afterward_teachers_count).to eq(initial_teachers_count)
  end

  it "does not create a teacher when the request includes a signed token from a non-admin user" do
    student = User.create(
                         role: :student,
                         first_name: "FirstName1",
                         last_name: "LastName1",
                         email: "student@example.com",
                         password: "85kseOlqqp!v1@a7",
                         password_confirmation: "85kseOlqqp!v1@a7"
                         )

    # Generate a valid JSON web token that indicates an admin role for testing purposes
    key = Rails.application.credentials.secret_key_base
    header = Base64.urlsafe_encode64("{\"alg\":\"HS256\"}")
    student_role_payload = Base64.urlsafe_encode64("{\"id\":#{student.id},\"role\":\"student\"}")
    header_and_payload = header + "." + student_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    student_token = header + "." + student_role_payload + "." + signature

    initial_teachers_count = User.where(role: "teacher").count
    post "/api/v1/users?user[first_name]=John&user[last_name]=Doe&user[email]=john%40example.com&user[password]=85kseOlqqp!v1@a7&user[password_confirmation]=85kseOlqqp!v1@a7&token=#{student_token}"
    afterward_teachers_count = User.where(role: "teacher").count
    expect(afterward_teachers_count).to eq(initial_teachers_count)
  end

  it "creates a teacher when the request includes a signed token from an admin user" do
    admin = User.create(
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
    admin_role_payload = Base64.urlsafe_encode64("{\"id\":#{admin.id},\"role\":\"admin\"}")
    header_and_payload = header + "." + admin_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    admin_token = header + "." + admin_role_payload + "." + signature

    initial_teachers_count = User.where(role: "teacher").count
    post "/api/v1/users?user[first_name]=John&user[last_name]=Doe&user[email]=john%40example.com&user[password]=85kseOlqqp!v1@a7&user[password_confirmation]=85kseOlqqp!v1@a7&token=#{admin_token}"
    afterward_teachers_count = User.where(role: "teacher").count
    expect(afterward_teachers_count).to eq(initial_teachers_count + 1)
  end
end
