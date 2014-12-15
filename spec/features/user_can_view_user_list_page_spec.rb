require 'rails_helper'

feature 'view the user list page' do
  scenario "non-logged-in user cannot view the page" do
    visit users_path
    expect(page).to have_title "Sign In - #{AppConfig.site_name}"
  end

  scenario 'logged-in user sees users page' do
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
    click_on "Add a User"
    fill_in "Name", with: "Newuser Name"
    fill_in "Email", with: "uu@aa.com"
    expect{ click_on "Save" }.to change{User.count}.by(1)
    expect(page).to have_css 'td', text: 'Newuser Name'
  end

  scenario 'non-admin user cannot add user' do
    user = sign_in_existing_user
    user.role = User.role(:contact)
    user.save
    visit users_path
    expect(page).to_not have_css 'p', text: "Add a User"
  end

  scenario 'admin user can edit a user', js: true do
    user = sign_in_existing_user
    user.update_attribute(:name, "editable user")
    user.role = User.role(:admin)
    visit users_path
    click_on "editable user"
    fill_in "Name", with: "changed name"
    click_on "Save"
    expect(page).to have_css 'td', text: 'changed name'
  end

  scenario 'admin user can delete a user', js: true do
    user = sign_in_existing_user
    user.role = User.role(:admin)
    user2 = FactoryGirl.create(:contact_user, organization: user.organization)
    user2.update_attribute(:name, "contact user")
    visit users_path
    click_on "delete-user-#{user2.id}"
    page.driver.browser.switch_to.alert.accept
    expect(page).to_not have_css 'td', text: 'contact user'
  end
end
