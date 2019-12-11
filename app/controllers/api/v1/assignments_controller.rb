class Api::V1::AssignmentsController < ApplicationController
  before_action :authorize_teacher
  before_action :verify_signature

  def create
    Assignment.create(assignment_params)
  end

  private

  def assignment_params
    params.require(:assignment).permit(:user_id, :lesson_id)
  end
end
