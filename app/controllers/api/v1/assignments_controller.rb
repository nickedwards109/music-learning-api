class Api::V1::AssignmentsController < ApplicationController
  before_action :authorize_teacher
  before_action :verify_signature

  def create
    if Assignment.create(assignment_params)
      lesson = Lesson.find(assignment_params[:lesson_id])
      student = User.find(assignment_params[:user_id])
      assignment_email_content = {
        student_first_name: student.first_name,
        email: student.email,
        lesson_title: lesson.title,
        lesson_url: "#{ENV['CLIENT_BASEURL']}/lessons/#{lesson.id}"
      }
      AssignmentMailer.with(params: assignment_email_content)
        .new_assignment_email
        .deliver_now
    else
      render json: {}, status: 404
    end
  end

  private

  def assignment_params
    params.require(:assignment).permit(:user_id, :lesson_id)
  end
end
