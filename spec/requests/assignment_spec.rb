require 'rails_helper'

RSpec.describe 'Assignments', type: :request do
  it 'can be created by a client authorized as a teacher' do
    teacher = User.create(
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
    teacher_role_payload = Base64.urlsafe_encode64("{\"id\":#{teacher.id},\"role\":\"teacher\"}")
    header_and_payload = header + "." + teacher_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    teacher_token = header + "." + teacher_role_payload + "." + signature

    student = User.create(
                          role: :student,
                          first_name: "StudentFirstName1",
                          last_name: "StudentLastName1",
                          email: "student@example.com",
                          password: "85kseOlqqp!v1@a7",
                          password_confirmation: "85kseOlqqp!v1@a7"
                          )

    lesson = Lesson.create(
      title: "This is a lesson title",
      text: "This is the text of a lesson."
    )

    expect(Assignment.all.count).to eq(0)

    post "/api/v1/assignments?assignment[user_id]=#{student.id}&assignment[lesson_id]=#{lesson.id}", headers: { TOKEN: teacher_token }

    expect(response).to have_http_status(204)
    expect(Assignment.all.count).to eq(1)
    expect(lesson.students.first.first_name).to eq("StudentFirstName1")
    expect(student.lessons.first.title).to eq("This is a lesson title")
  end

  it 'cannot be created by a client not authorized as a teacher' do
    student = User.create(
                          role: :student,
                          first_name: "StudentFirstName1",
                          last_name: "StudentLastName1",
                          email: "student@example.com",
                          password: "85kseOlqqp!v1@a7",
                          password_confirmation: "85kseOlqqp!v1@a7"
                          )

    lesson = Lesson.create(
      title: "This is a lesson title",
      text: "This is the text of a lesson."
    )

    expect(Assignment.all.count).to eq(0)

    post "/api/v1/assignments?assignment[user_id]=#{student.id}&assignment[lesson_id]=#{lesson.id}"

    expect(response).to have_http_status(404)
    expect(Assignment.all.count).to eq(0)
    expect(lesson.students.count).to eq(0)
    expect(student.lessons.count).to eq(0)
  end
end
