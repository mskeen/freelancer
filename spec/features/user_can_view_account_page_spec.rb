require 'rails_helper'

feature 'view the account page when logged in' do

  scenario "non-logged-in user cannot view the page" do
    visit edit_account_path
    expect(page).to have_title "Sign In - #{AppConfig.site_name}"
  end

  scenario 'user sees account page' do
    user = sign_in_existing_user
    visit root_path
    click_on  'Account'
    expect(page).to have_title "Account - #{AppConfig.site_name}"
    expect(page).to have_css 'h1',
      text: "Your Account Details"
  end

  scenario 'user can update organization name' do
    user = sign_in_existing_user
    user.organization.update_attribute(:name, 'To Change')
    visit edit_account_path
    fill_in "Organization Name", with: "Updated"
    click_on "Save"
    visit root_path
    expect(page).to have_css 'h1', text: 'Updated'
  end

  scenario 'user can update password' do
    user = sign_in_existing_user
    visit edit_account_path
    fill_in "Current password", with: "password"
    fill_in "Password", with: "password2"
    fill_in "Password confirmation", with: "password2"
    click_on "Change"
    expect(page).to have_css 'div.alert', text: 'password has been updated'
    click_on 'Sign Out'
    click_on 'Log In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password2'
    click_on 'Sign in'
    expect(page).to have_css 'h1', text: 'Dashboard'
  end
end
