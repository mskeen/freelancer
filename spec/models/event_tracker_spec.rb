require 'rails_helper'

RSpec.describe EventTracker, type: :model do

  # defaults
  it 'defaults interval to "hourly"' do
    et = EventTracker.new
    expect(et.interval.name).to eq :hourly
  end

  it 'defaults status to "pending"' do
    et = EventTracker.new
    expect(et.status.name).to eq :pending
  end

  # validations
  it 'requires a name' do
    expect(FactoryGirl.build(:event_tracker)).to be_valid
    expect(FactoryGirl.build(:event_tracker, name: nil)).to_not be_valid
  end

  it 'requires an interval_cd' do
    expect(FactoryGirl.build(:event_tracker, interval_cd: nil)).to_not be_valid
  end

  it 'requires a status_cd' do
    expect(FactoryGirl.build(:event_tracker, status_cd: nil)).to_not be_valid
  end

  it 'requires an email' do
    expect(FactoryGirl.build(:event_tracker, email: nil)).to_not be_valid
  end

  it 'requires multiple emails to be separated by commas' do
    et = FactoryGirl.build(:event_tracker, email: 'e1@sample.com e2@sample.com')
    expect(et).to_not be_valid
    expect(et.errors[:email]).to include 'must be valid format and separated by commas'
  end

  it 'requires valid email formats' do
    et = FactoryGirl.build(:event_tracker, email: 'e1sample.com, e2@sample.com')
    expect(et).to_not be_valid
    expect(et.errors[:email]).to include 'must be valid format and separated by commas'
  end

  # associations
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :organization }
  end

  describe EventTracker, 'token' do
    it 'is generated on creation' do
      tracker = FactoryGirl.create(:event_tracker, name: 't1')
      expect(tracker.token.size).to be 12
    end

    it "is used as the EventTracker's to_param" do
      tracker = FactoryGirl.create(:event_tracker, name: 't1')
      expect(tracker.to_param).to be tracker.token
    end
  end

  describe EventTracker, 'active' do
    it 'only returns non-deleted items' do
      FactoryGirl.create(:event_tracker, name: 't2')
      FactoryGirl.create(:event_tracker, is_deleted: true, name: 't3')
      expect(EventTracker.active.count).to eq 1
    end
  end
end
