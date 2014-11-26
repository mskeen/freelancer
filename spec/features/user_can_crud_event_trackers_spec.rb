require 'rails_helper'

feature 'user can perform CRUD operations on event trackers' do

  # Index -----------------------------------------------
  feature 'index' do

    scenario 'shows a list of user''s trackers' do
      user = sign_in_existing_user
      tracker1 = FactoryGirl.create(:event_tracker, name: 'tracker1', user: user)
      tracker2 = FactoryGirl.create(:event_tracker, name: 'tracker2', user: user)
      click_on 'Events'

      expect(page).to have_title 'Event Tracking'
      expect(page).to have_css 'tr.event-tracker-row', text: tracker1.name
      expect(page).to have_css 'tr.event-tracker-row', text: tracker2.name
    end

    scenario 'doesn''t show other user''s trackers' do
      user = sign_in_existing_user
      tracker1 = FactoryGirl.create(:event_tracker, name: 'tracker1', user: user)

      user2 = FactoryGirl.create(:user, name: 'user 2', email: 'email2@sample.com')
      tracker2 = FactoryGirl.create(:event_tracker, name: 'tracker2', user: user2)
      click_on 'Events'

      expect(page).to have_title 'Event Tracking'
      expect(page).to have_css 'tr.event-tracker-row', text: tracker1.name
      expect(page).to_not have_css 'tr.event-tracker-row', text: tracker2.name
    end

  end

  # Create -----------------------------------------------
  feature 'create' do

    scenario 'form for new tracker displays correctly' do
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

    scenario 'successfully create a tracker' do
      sign_in_existing_user

      click_on 'Events'
      click_on 'New Event Tracker'
      fill_in 'Name', with: 'test event'
      fill_in 'Email', with: 'test@sample.com'
      fill_in 'Notes', with: 'This is a description'
      choose '30 Minutes'
      click_on 'Save'

      expect(page).to have_title "test event - #{AppConfig.site_name}"
      expect(page).to have_text "test event"
    end

  end

  # Show -----------------------------------------------

  # Edit -----------------------------------------------

  # Delete -----------------------------------------------

end
