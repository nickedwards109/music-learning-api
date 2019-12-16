class Api::V1::LessonsController < ApplicationController
  before_action :authorize_lesson_viewer, only: [:show]
  before_action :authorize_teacher, only: [:index, :create]
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

  def index
    lessons = Lesson.all
    render json: {
      lessons: lessons
    }
  end

  private

  def lesson_params
    params.require(:lesson).permit(:title, :text, assets_attributes: [ :storageURL ])
  end

  def authorize_lesson_viewer
    # Authorize assigned students to view the lesson
    if lesson_id = request.fullpath.split('/').last.to_i
      token = JsonWebToken.decode(request.headers["TOKEN"])[0]
      if token["role"] == "student"
        student_id = token["id"]
        if Assignment.where(lesson_id: lesson_id).where(user_id: student_id).count < 1
          render json: {}, status: 404
        end
      end

    # Authorize any teacher to view the lesson
    elsif !Authorization.authorize(request, :teacher)
     render json: {}, status: 404
    end
  end
end
