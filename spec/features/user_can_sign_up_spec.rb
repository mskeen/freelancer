require 'rails_helper'

feature 'user can sign up' do
  scenario 'successfully' do
    email = 'a@sample.com'
    organization_name = "Widgets Co."
    visit root_path

    click_on 'Sign Up'

    fill_in 'Name', with: 'first last'
    fill_in 'Email', with: email
    fill_in 'Organization Name', with: organization_name
    fill_in 'Password', with: 'password'
    click_on 'Sign up'

    user = User.find_by_email(email)
    user.confirmed_at = Time.now
    user.save

    click_on 'Log In'

    fill_in 'Email', with: email
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_title "Dashboard - #{AppConfig.site_name}"
    expect(page).to have_text organization_name
  end
end
