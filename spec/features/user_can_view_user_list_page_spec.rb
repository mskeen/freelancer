require 'rails_helper'

feature 'view the user list page' do
  scenario "non-logged-in user cannot view the page" do
    visit users_path
    expect(page).to have_title "Sign In - #{AppConfig.site_name}"
  end

  scenario 'logged-in user sees users page', js: true do
    user = sign_in_existing_user
    visit root_path

    click_on  'Users'
    expect(page).to have_title "User Accounts - #{AppConfig.site_name}"
    expect(page).to have_css 'h1', text: "User Accounts"
  end

  scenario 'admin user can add a user', js: true do
    user = sign_in_existing_user
    user.role = User.role(:admin)
    visit users_path
    expect(page).to have_css 'p', text: "Add a User"
    click_on "Add a User"
    fill_in "Name", with: "User Name"
    fill_in "Email", with: "uu@aa.com"
    expect{ click_on "Save" }.to change{User.count}.by(1)
  end

  scenario 'non-admin user cannot add user' do
    user = sign_in_existing_user
    user.role = User.role(:contact)
    user.save
    visit users_path
    expect(page).to_not have_css 'p', text: "Add a User"
  end
end
