require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "new user email" do
    it "is sent to the user's email address, has a subject, and has a body that contains a user's name and elements of a query string" do
      mail = UserMailer.with(params: {role: "teacher", first_name: "John", last_name: "Doe", email: "johndoe@example.com"}).set_password_email.deliver_now
      expect(mail.to[0]).to eq("johndoe@example.com")
      expect(mail.subject).to eq("Set a password for your new account")
      expect(mail.body).to include("John")
      expect(mail.body).to include("teacher")
      expect(mail.body).to include("/set_password?email=johndoe%40example.com")
      expect(mail.body).to include("uuid=")
    end
  end

  describe "password reset email" do
    it "is sent to the user's email address, has a subject, and has a body that contains a user's name and elements of a query string" do
      mail = UserMailer.with(params: {first_name: "John", email: "johndoe@example.com"}).reset_password_email.deliver_now
      expect(mail.to[0]).to eq("johndoe@example.com")
      expect(mail.subject).to eq("Reset your password")
      expect(mail.body).to include("John")
      expect(mail.body).to include("/reset_password?email=johndoe%40example.com")
      expect(mail.body).to include("uuid=")
    end
  end
end
