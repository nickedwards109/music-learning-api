require 'rails_helper'

RSpec.feature "Admin user", type: :feature do
  scenario "Admin user logs in" do
    # The first admin user in the database needs to be created without a GUI
    # In production, this would be through a Rails console
    admin = User.create(role: :admin,
                        first_name: "FirstName1",
                        last_name: "LastName1",
                        email: "admin@example.com",
                        password: "85kseOlqqp!v1@a7"
                        )

    visit admin_login_path
    fill_in 'Email', with: "admin@example.com"
    fill_in 'Password', with: "85kseOlqqp!v1@a7"
    click_on 'Login'
    expect(page).to have_current_path(admin_dashboard_path)
  end
end
