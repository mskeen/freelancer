require 'rails_helper'

feature 'user can sign up' do
  scenario 'successfully' do
    user = FactoryGirl.build(:user)
    visit root_path

    click_on 'Sign Up'

    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Organization Name', with: user.organization.name
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    new_user = User.find_by_email(user.email)
    new_user.confirmed_at = Time.now
    new_user.save

    click_on 'Log In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Sign in'

    expect(page).to have_title "Dashboard - #{AppConfig.site_name}"
    expect(page).to have_text user.organization.name
  end

  scenario 'unsuccessfuly' do
    user = FactoryGirl.build(:user)
    visit root_path

    click_on 'Sign Up'

    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Organization Name', with: ''
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    expect(page).to have_text "Organization name can't be blank"

  end
end
