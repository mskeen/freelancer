require 'rails_helper'

feature 'user can sign up' do
  scenario 'successfully' do
    user = FactoryGirl.build(:user)
    sign_up_and_confirm(user)

    sign_in(user)

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
