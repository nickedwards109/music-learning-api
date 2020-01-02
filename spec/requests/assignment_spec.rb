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

  it 'only allows a student to view the lesson if the lesson has been assigned to that student' do
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

    student_token = SpecHelper.generate_token(student)

    get "/api/v1/lessons/#{lesson.id}", headers: { TOKEN: student_token }
    expect(response).to have_http_status(404)

    Assignment.create(lesson_id: lesson.id, user_id: student.id)

    get "/api/v1/lessons/#{lesson.id}", headers: { TOKEN: student_token }
    expect(response).to have_http_status(200)
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

  it "responds to a student request for IDs of the student's assigned lessons" do
    student = User.create(
                          role: :student,
                          first_name: "StudentFirstName1",
                          last_name: "StudentLastName1",
                          email: "student@example.com",
                          password: "85kseOlqqp!v1@a7",
                          password_confirmation: "85kseOlqqp!v1@a7"
                          )

    student_token = SpecHelper.generate_token(student)

    lesson1 = Lesson.create(
      title: "This is a lesson title",
      text: "This is the text of a lesson."
    )

    lesson2 = Lesson.create(
      title: "This is a lesson title",
      text: "This is the text of a lesson."
    )

    Assignment.create(user_id: student.id, lesson_id: lesson1.id)
    Assignment.create(user_id: student.id, lesson_id: lesson2.id)

    get "/api/v1/assignments", params: {student_id: student.id}, headers: { TOKEN: student_token }

    parsed_response = JSON.parse(response.body)
    expect(parsed_response["lessons"].count).to eq(2)
    expect(parsed_response["lessons"][0]["id"]).to eq(lesson1.id)
    expect(parsed_response["lessons"][0]["title"]).to eq(lesson1.title)

    get "/api/v1/assignments", params: {student_id: student.id}
    expect(response).to have_http_status(404)
  end
end
