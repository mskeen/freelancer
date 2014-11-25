require 'rails_helper'

feature 'user can sign in' do
  scenario 'successful login' do
    user = FactoryGirl.build(:user)
    user.confirmed_at = Time.now
    user.save

    visit root_path

    click_on 'Log In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_on 'Sign in'

    expect(page).to have_title 'Dashboard - ' \
      "#{AppConfig.site_name}"
  end
end
