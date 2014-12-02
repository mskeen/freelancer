require 'rails_helper'

feature 'user can ping an event tracker' do

  scenario 'unsuccessful ping' do
    visit ping_event_tracker_url('notfound')

    expect(page).to have_text 'ok'
  end

  scenario 'successful ping' do
    tracker = FactoryGirl.create(:event_tracker, name: 'tracker1')
    visit ping_event_tracker_url(tracker)

    tracker.reload
    expect(page).to have_text 'ok'
    expect(tracker.last_ping_at).to_not be_nil
    expect(tracker.pings.count).to eq 1
  end

  scenario 'can set comment & time_taken fields' do
    tracker = FactoryGirl.create(:event_tracker, name: 'tracker1')
    visit ping_event_tracker_url(tracker) + '?time=20.2&comment=hello'

    expect(tracker.pings.first.task_length).to eq '20.2'
    expect(tracker.pings.first.comment).to eq 'hello'
  end
end
