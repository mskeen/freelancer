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
    it { should have_many :pings }
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

  describe "due?" do
    it 'is true when 1 hour check was done more than an hour ago' do
      t = FactoryGirl.create(:event_tracker, last_checked_at: Time.zone.now - 65.minutes)
      expect(t).to be_due
    end

    it 'is false when 1 hour check was 10 minutes ago' do
      t = FactoryGirl.create(:event_tracker, last_checked_at: Time.zone.now - 10.minutes)
      expect(t).to_not be_due
    end

    it 'is true when 1 day check was done more than a day ago' do
      t = FactoryGirl.create(:event_tracker, interval_cd: EventTracker.interval(:daily).id, last_checked_at: Time.zone.yesterday)
      expect(t).to be_due
    end

    it 'is true for a new Tracker' do
      t = FactoryGirl.create(:event_tracker, interval_cd: EventTracker.interval(:daily).id)
      expect(t).to be_due
    end
  end

  describe "scope: due" do
    it "includes only items that are currently due to be checked" do
      t1 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now - 65.minutes)
      t2 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now + 10.minutes)
      t3 = FactoryGirl.create(:event_tracker, interval_cd: EventTracker.interval(:daily).id, next_check_at: Time.zone.yesterday)
      ids = EventTracker.due.map(&:id)
      expect(ids).to include t1.id
      expect(ids).to_not include t2.id
      expect(ids).to include t3.id
    end
  end

  describe "scope: running" do
    it "includes only items that are currently ok or alert status" do
      t1 = FactoryGirl.create(:event_tracker, status_cd: EventTracker.status(:ok).id)
      t2 = FactoryGirl.create(:event_tracker, status_cd: EventTracker.status(:alert).id)
      t3 = FactoryGirl.create(:event_tracker, status_cd: EventTracker.status(:paused).id)
      t4 = FactoryGirl.create(:event_tracker, status_cd: EventTracker.status(:pending).id)
      ids = EventTracker.running.map(&:id)
      expect(ids).to include t1.id
      expect(ids).to include t2.id
      expect(ids).to_not include t3.id
      expect(ids).to_not include t4.id
    end
  end

  describe "check" do
    it "reports true when recently pinged" do
      t1 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now - 65.minutes)
      t1.ping
      t1.reload
      expect(t1.check(Time.zone.now)).to eq true
      expect(t1.status.name).to eq :ok
    end

    it "reports false when not recently pinged" do
      t1 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now - 65.minutes, last_ping_at: Time.zone.now - 90.minutes)
      t1.status = EventTracker.status(:ok)
      expect(t1.check(Time.zone.now)).to eq false
      expect(t1.status.name).to eq :alert
    end
  end

end
