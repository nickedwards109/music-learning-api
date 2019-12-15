require 'rails_helper'

RSpec.describe "Teacher Dashboard", type: :request do
  it "responds with the teacher's name" do
    teacher = User.create(
                      role: :teacher,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "teacher@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    teacher_token = SpecHelper.generate_token(teacher)

    get "/api/v1/teacher/dashboard", params: {}, headers: { TOKEN: teacher_token }

    parsed_response = JSON.parse(response.body)

    first_name = parsed_response["firstName"]
    expect(first_name).to eq(teacher.first_name)
  end
end
