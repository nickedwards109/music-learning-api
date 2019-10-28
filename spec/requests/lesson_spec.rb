require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  it "creates a lesson and its associated assets, and renders JSON containing the new lesson's id" do
    user = User.create(
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
    teacher_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"role\":\"teacher\"}")
    header_and_payload = header + "." + teacher_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    teacher_token = header + "." + teacher_role_payload + "." + signature

    lesson_title = "This is a title"
    lesson_text = "This is text."
    asset_storage_url= "http://www.example.com/assets/1"

    lesson_count_before = Lesson.all.count
    asset_count_before = Asset.all.count

    post "/api/v1/lessons", params: {lesson: {title: lesson_title, text: lesson_text, assets_attributes: [{storageURL: asset_storage_url}]}}, headers: { TOKEN: teacher_token }

    lesson_count_after = Lesson.all.count
    asset_count_after = Asset.all.count
    expect(lesson_count_after).to eq(lesson_count_before + 1)
    expect(asset_count_after).to eq(asset_count_before + 1)

    parsed_response = JSON.parse(response.body)

    expect(parsed_response).to have_key("lesson_id")
  end

  it "responds to a lesson show endpoint" do
    lesson = Lesson.create(title: "This is a title", text: "This is text.")
    storageURL = 'http://www.example.com/assets/1'
    asset = Asset.create(storageURL: storageURL, lesson_id: lesson.id)

    user = User.create(
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
    teacher_role_payload = Base64.urlsafe_encode64("{\"id\":#{user.id},\"role\":\"teacher\"}")
    header_and_payload = header + "." + teacher_role_payload
    hashed_header_and_payload = OpenSSL::HMAC.digest(OpenSSL::Digest.new("sha256"), key, header_and_payload)
    signature = Base64.urlsafe_encode64(hashed_header_and_payload).gsub("=", "")
    teacher_token = header + "." + teacher_role_payload + "." + signature

    get "/api/v1/lessons/#{lesson.id}", headers: { TOKEN: teacher_token }

    response_lesson = JSON.parse(response.body)
    expect(response_lesson["id"]).to eq(lesson.id)
    expect(response_lesson["title"]).to eq(lesson.title)
    expect(response_lesson["text"]).to eq(lesson.text)
    expect(response_lesson["assets"][0]["storageURL"]).to eq(storageURL)
  end
end
