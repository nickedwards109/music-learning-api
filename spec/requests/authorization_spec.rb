require 'rails_helper'

RSpec.describe "Authorization", type: :request do
  it "allows access to the admin dashboard if the request contains a valid JSON web token indicating an admin role in the payload" do
    admin = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    admin_token = SpecHelper.generate_token(admin)

    # If a user tries to access an admin dashboard with no token,
    # don't tell the user what happened and instead return a 404
    # get "/api/v1/admin/dashboard"
    # expect(response).to have_http_status(404)

    # If a user tries to access an admin dashboard with an invalid token,
    # don't tell the user what happened and instead return a 404
    # get "/api/v1/admin/dashboard?token=1234"
    # expect(response).to have_http_status(404)

    # If a user tries to access an admin dashboard with a valid token, return a 200
    get "/api/v1/admin/dashboard", params: {}, headers: { TOKEN: admin_token }
    expect(response).to have_http_status(200)
  end

  it "does not allow access to the admin dashboard if the request contains a JSON web token indicating an student role in the payload" do
    student = User.create(
                      role: :student,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    student_token = SpecHelper.generate_token(student)

    # If a student tries to access an admin dashboard, return a 404
    get "/api/v1/admin/dashboard", params: {}, headers: { TOKEN: student_token}
    expect(response).to have_http_status(404)
  end
end
