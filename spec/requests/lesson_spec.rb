require 'rails_helper'

RSpec.describe "Lessons", type: :request do
  it "renders JSON for the lesson show page when a lesson and its associated asset are created" do
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

    expect(parsed_response).to have_key("lesson")
    expect(parsed_response["lesson"]).to have_key("title")
    expect(parsed_response["lesson"]).to have_key("text")

    expect(parsed_response).to have_key("assets")
    expect(parsed_response["assets"].class).to eq(Array)
    expect(parsed_response["assets"][0]).to have_key("storageURL")
    expect(parsed_response["assets"][0]).to have_key("lesson_id")
  end
end
