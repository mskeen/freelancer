require 'rails_helper'

feature 'view the user list page when logged in' do
  scenario "non-logged-in user cannot view the page" do
    visit users_path
    expect(page).to have_title "Sign In - #{AppConfig.site_name}"
  end

  scenario 'user sees home page' do
    user = sign_in_existing_user
    visit root_path

    click_on  'Users'
    expect(page).to have_title "User Accounts - #{AppConfig.site_name}"
    expect(page).to have_css 'h1',
      text: "Organization User Accounts"
  end
end
