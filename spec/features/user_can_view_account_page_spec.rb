require 'rails_helper'

feature 'view the account page when logged in' do
  scenario "non-logged-in user cannot view the page" do
    visit edit_account_path
    expect(page).to have_title "Sign In - #{AppConfig.site_name}"
  end

  scenario 'user sees home page' do
    user = sign_in_existing_user
    visit root_path

    click_on  'Account'
    expect(page).to have_title "Account - #{AppConfig.site_name}"
    expect(page).to have_css 'h1',
      text: "Your Account Details"
  end
end
