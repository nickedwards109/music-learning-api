require 'rails_helper'

RSpec.describe "Student Dashboard", type: :request do
  it "responds with the student's name" do
    student = User.create(
                      role: :student,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "student@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    student_token = SpecHelper.generate_token(student)

    get "/api/v1/student/dashboard", params: {}, headers: { TOKEN: student_token }
    parsed_response = JSON.parse(response.body)
    first_name = parsed_response["firstName"]
    expect(first_name).to eq(student.first_name)
  end
end
