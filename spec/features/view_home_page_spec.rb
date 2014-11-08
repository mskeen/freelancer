require 'rails_helper'

feature 'view the home page when not logged in' do
  scenario 'user sees correct page' do
    visit root_path

    expect(page).to have_title "Home - #{APP_CONFIG['site_name']}"
    expect(page).to have_css 'h1', text: APP_CONFIG['site_name']
  end
end
