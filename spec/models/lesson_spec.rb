require 'rails_helper'

RSpec.describe Lesson, type: :model do
  # TODO decouple Lesson and Asset implementations in the tests with mocks
  describe "creating a new lesson record" do
    it "validates for the presence of the title field" do
      no_title_lesson = Lesson.create(text: "This is the text of a lesson.")
      expect(no_title_lesson).not_to be_valid

      valid_lesson = Lesson.create(title: "This is a title.",
                                   text: "This is the text of the lesson.")
      expect(valid_lesson).to be_valid
    end

    it "can be associated with Asset objects" do
      asset = Asset.create(storageURL: "https://www.example.com/example.wmv")
      lesson = Lesson.create(title: "This is a title.",
                             text: "This is the text of the lesson.")
      lesson.assets << asset
      expect(lesson.assets.first).to eq(asset)
      expect(lesson.assets.first.storageURL).to eq("https://www.example.com/example.wmv")
    end
  end
end
