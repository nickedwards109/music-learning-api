require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "new user email" do
    it "has to and from email addresses, a subject, and a name in the body" do
      mail = UserMailer.with(params: {role: "teacher", first_name: "John", last_name: "Doe", email: "johndoe@example.com"}).set_password_email.deliver_now
      expect(mail.to[0]).to eq("johndoe@example.com")
      expect(mail.subject).to eq("Set a password for your new account")
      expect(mail.body).to include("John")
      expect(mail.body).to include("teacher")
      expect(mail.body).to include("/set_password?uuid=")
    end
  end
end
