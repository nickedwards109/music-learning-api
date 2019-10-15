require 'rails_helper'

RSpec.describe Asset, type: :model do
  # TODO decouple Lesson and Asset implementations in the tests with mocks
  describe "creating a new asset" do
    it "validates for the storageUrl field" do
      no_url_asset = Asset.create()
      expect(no_url_asset).not_to be_valid
    end

    it "belongs to a lesson" do
      lesson = Lesson.create(title: "This is a title.",
                             text: "This is the text of the lesson.")
      asset = Asset.create(storageURL: "https://www.example.com/example.wmv",
                           lesson_id: lesson.id)
      expect(asset).to be_valid
      expect(asset.lesson).to eq(lesson)
    end
  end
end
