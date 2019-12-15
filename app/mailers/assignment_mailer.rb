class AssignmentMailer < ApplicationMailer
  def new_assignment_email
    @assignment_email_content = params[:params]
    mail(
      to: @assignment_email_content[:email],
      subject: "A lesson has been assigned to you: #{@assignment_email_content[:lesson_title]}"
    )
  end
end
