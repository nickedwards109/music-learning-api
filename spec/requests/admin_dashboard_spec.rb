require 'rails_helper'

RSpec.describe "Admin Dashboard", type: :request do
  it "responds with the admin's name" do
    admin = User.create(
                      role: :admin,
                      first_name: "FirstName1",
                      last_name: "LastName1",
                      email: "admin@example.com",
                      password: "85kseOlqqp!v1@a7",
                      password_confirmation: "85kseOlqqp!v1@a7"
                      )

    admin_token = SpecHelper.generate_token(admin)

    get "/api/v1/admin/dashboard", params: {}, headers: { TOKEN: admin_token }

    parsed_response = JSON.parse(response.body)

    first_name = parsed_response["firstName"]
    expect(first_name).to eq(admin.first_name)
  end
end
