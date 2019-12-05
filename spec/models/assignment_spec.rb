 require 'rails_helper'

 RSpec.describe Assignment, type: :model do
   it "has fields for a student id and a lesson id" do
     student = User.create(
        role: :student,
        first_name: "StudentFirstName",
        last_name: "StudentLastName",
        email: "student@example.com",
        password: "85kseOlqqp!v1@a7",
        password_confirmation: "85kseOlqqp!v1@a7"
      )
      lesson = Lesson.create(
        title: "This is a lesson title",
        text: "This is the text of a lesson."
      )

      assignment = Assignment.create(student_id: student.id, lesson_id: lesson.id)
      expect(assignment).to be_valid
   end

   it "validates for presence of a student id and a lesson id" do
     student = User.create(
        role: :student,
        first_name: "StudentFirstName",
        last_name: "StudentLastName",
        email: "student@example.com",
        password: "85kseOlqqp!v1@a7",
        password_confirmation: "85kseOlqqp!v1@a7"
      )
      lesson = Lesson.create(
        title: "This is a lesson title",
        text: "This is the text of a lesson."
      )

     no_student_assignment = Assignment.create(lesson_id: lesson.id)
     expect(no_student_assignment).to_not be_valid

     no_lesson_assignment = Assignment.create(student_id: student.id)
     expect(no_lesson_assignment).to_not be_valid
   end
 end
