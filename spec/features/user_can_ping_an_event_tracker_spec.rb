require 'rails_helper'

feature 'user can ping an event tracker' do

  scenario 'unsuccessful ping' do
    visit ping_event_tracker_url('notfound')

    expect(page).to have_text 'ok'
  end

  scenario 'successful ping' do
    tracker = FactoryGirl.create(:event_tracker, name: 'tracker1')
    visit ping_event_tracker_url(tracker)

    expect(page).to have_text 'ok'
    expect(tracker.last_ping_at).to_not be_nil
    expect(tracker.pings.count).to eq 1
  end
end
