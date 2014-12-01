require 'rails_helper'

RSpec.describe EventTracker, type: :model do

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :organization }
  end

  describe EventTracker, 'token' do
    it 'is generated on creation' do
      tracker = FactoryGirl.create(:event_tracker, name: "t1")
      expect(tracker.token.size).to be 12
    end
  end

  describe EventTracker, 'active' do
    it "only returns non-deleted items" do
      FactoryGirl.create(:event_tracker, name: "t2")
      FactoryGirl.create(:event_tracker, is_deleted: true, name: "t3")
      expect(EventTracker.active.count).to eq 1
    end
  end
end
