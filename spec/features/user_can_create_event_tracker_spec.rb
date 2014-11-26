require 'rails_helper'

feature 'user can create an event tracker' do

  scenario 'form displays correctly' do
    user = sign_in_existing_user
    click_on 'Events'
    click_on 'New Event Tracker'

    expect(page).to have_title 'New Event Tracker'
    expect(find_field('Email').value).to eq user.email
    within('form') {
      expect(page).to have_content '30 Minutes'
      expect(page).to have_content 'Hourly'
      expect(page).to have_content 'Daily'
      expect(page).to have_content 'Weekly'
      expect(page).to have_content 'Monthly'
    }
  end

  scenario 'successfully' do
    sign_in_existing_user

    click_on 'Events'
    click_on 'New Event Tracker'
    fill_in 'Name', with: 'test event'
    fill_in 'Email', with: 'test@sample.com'
    fill_in 'Notes', with: 'This is a description'
    choose '30 Minutes'
    click_on 'Save'

    expect(page).to have_title "Event Tracking - #{AppConfig.site_name}"
    expect(page).to have_text "test event"
  end

end
