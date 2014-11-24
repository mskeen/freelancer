require 'rails_helper'

feature 'view the home page when not logged in' do
  scenario 'user sees home page' do
    visit root_path

    expect(page).to have_title "Home - #{Rails.application.secrets.site_name}"
    expect(page).to have_css 'h1',
      text: "Welcome to #{Rails.application.secrets.site_name}!"
  end
end
