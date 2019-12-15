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

    teacher_token = SpecHelper.generate_token(teacher)

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
    expect(ActionMailer::Base.deliveries.count).to eq(0)

    post "/api/v1/assignments?assignment[user_id]=#{student.id}&assignment[lesson_id]=#{lesson.id}", headers: { TOKEN: teacher_token }

    expect(response).to have_http_status(204)
    expect(Assignment.all.count).to eq(1)
    expect(ActionMailer::Base.deliveries.count).to eq(1)
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
    expect(ActionMailer::Base.deliveries.count).to eq(0)

    post "/api/v1/assignments?assignment[user_id]=#{student.id}&assignment[lesson_id]=#{lesson.id}"

    expect(response).to have_http_status(404)
    expect(Assignment.all.count).to eq(0)
    expect(ActionMailer::Base.deliveries.count).to eq(0)
    expect(lesson.students.count).to eq(0)
    expect(student.lessons.count).to eq(0)
  end
end
