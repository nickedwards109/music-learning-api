require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creating a new user record" do
    it "validates for the presence of fields" do
      # This test doesn't get slowed down by testing for validations on every
      # single field; it tests a few fields and reasonably assumes that if some
      # validations are working and nobody is deleting validation code in the
      # model, the other validations would be working as well.
      no_role_user = User.create(first_name: "FirstName1",
                                 last_name: "LastName1",
                                 email: "admin@example.com",
                                 password: "85kseOlqqp!v1@a7",
                                 password_confirmation: "85kseOlqqp!v1@a7"
                                 )
      expect(no_role_user).not_to be_valid

      no_email_user = User.create(role: :admin,
                                  first_name: "FirstName1",
                                  last_name: "LastName1",
                                  password: "85kseOlqqp!v1@a7",
                                  password_confirmation: "85kseOlqqp!v1@a7"
                                  )
      expect(no_email_user).not_to be_valid

      mismatched_passwords_user = User.create(role: :admin,
                                              first_name: "FirstName1",
                                              last_name: "LastName1",
                                              email: "admin@example.com",
                                              password: "85kseOlqqp!v1@a7",
                                              password_confirmation: "nomatch"
                                              )
      expect(mismatched_passwords_user).not_to be_valid

      valid_user = User.create(role: :admin,
                               first_name: "FirstName1",
                               last_name: "LastName1",
                               email: "admin@example.com",
                               password: "85kseOlqqp!v1@a7",
                               password_confirmation: "85kseOlqqp!v1@a7"
                               )
      expect(valid_user).to be_valid
    end
  end

  describe "authenticating a user" do
    it "authenticates a user who supplies the correct password" do
      correct_password = "85kseOlqqp!v1@a7"
      incorrect_password = "1234"

      user = User.create(role: :admin,
                         first_name: "FirstName1",
                         last_name: "LastName1",
                         email: "admin@example.com",
                         password: correct_password,
                         password_confirmation: correct_password
                         )

      # User#authenticate returns false when the input password is incorrect,
      # and returns the user instance when the input password is correct.

      authenticated = user.authenticate(incorrect_password)
      expect(authenticated).to eq(false)

      authenticated = user.authenticate(correct_password)
      expect(authenticated).to eq(user)
    end
  end
end
