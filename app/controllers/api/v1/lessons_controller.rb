class Api::V1::LessonsController < ApplicationController
  before_action :authorize_teacher
  before_action :verify_signature

  def create
    lesson = Lesson.create(lesson_params)
    lesson_assets = lesson.assets
    if lesson.valid? && lesson_assets.count > 0
      render json: {lesson_id: lesson.id}, status: 200
    else
      render json: {}, status: 404
    end
  end

  def show
    lesson = Lesson.find(params["id"])
    render json: {
      id: lesson.id,
      title: lesson.title,
      text: lesson.text,
      assets: lesson.assets
    }
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :text, assets_attributes: [ :storageURL ])
  end

  def authorize_teacher
    if !Authorization.authorize(request, :teacher)
     render json: {}, status: 404
   end
  end
end
