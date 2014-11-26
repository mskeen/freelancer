require 'rails_helper'

RSpec.describe EventTracker, :type => :model do

  it "generates a token on creation" do
    tracker = FactoryGirl.build(:event_tracker)
    tracker.save!
    expect(tracker.token.size).to be 12
  end
end
