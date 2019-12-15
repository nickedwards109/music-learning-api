require "rails_helper"

RSpec.describe AssignmentMailer, type: :mailer do
  describe "new assignment email" do
    it "is sent to the student's email address, has a subject, and has a body that contains a lesson's title and a link to the lesson" do
      mail = AssignmentMailer.with(
        params: {
          student_first_name: "John",
          email: "john@example.com",
          lesson_title: "How to tune the harp",
          lesson_url: "http://localhost:3001/lessons/1"}
        )
        .new_assignment_email
        .deliver_now
      expect(mail.to[0]).to eq("john@example.com")
      expect(mail.subject).to eq("A lesson has been assigned to you: How to tune the harp")
      expect(mail.body).to include("John")
      expect(mail.body).to include("http://localhost:3001/lessons/1")
    end
  end
end
