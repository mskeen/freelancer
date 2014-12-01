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

      user2 = FactoryGirl.create(:user, id: 2, name: 'user 2', email: 'email2@sample.com')
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
  feature 'show' do
    scenario 'an existing tracker''s details can be viewed' do
      user = sign_in_existing_user
      tracker1 = FactoryGirl.create(:event_tracker,
        name: 'tracker1', user: user,
        interval_cd: EventTracker.interval(:minutes_30).id )

      click_on 'Events'
      click_on 'tracker1'

      expect(page).to have_title "tracker1 - #{AppConfig.site_name}"
      expect(page).to have_text "30 Minutes"
    end
  end


  # Edit -----------------------------------------------
  feature 'edit' do
    scenario 'user can change tracker details' do
      user = sign_in_existing_user
      tracker1 = FactoryGirl.create(:event_tracker,
        name: 'tracker1', user: user,
        interval_cd: EventTracker.interval(:minutes_30).id )

      click_on 'Events'
      click_on 'tracker1'
      click_on 'Edit'

      choose 'Daily'
      click_on 'Save'

      expect(page).to have_title "tracker1 - #{AppConfig.site_name}"
      expect(page).to have_text "Daily"
    end
  end

  # Delete -----------------------------------------------
  feature 'delete' do
    scenario 'user can change delete a tracker' do
      user = sign_in_existing_user
      tracker1 = FactoryGirl.create(:event_tracker,
        name: 'tracker1', user: user,
        interval_cd: EventTracker.interval(:minutes_30).id )

      click_on 'Events'
      click_on 'tracker1'
      click_on 'Delete'

      expect(page).to have_title "Event Tracking - #{AppConfig.site_name}"
      expect(page).to_not have_text "tracker1"
    end
  end

end
