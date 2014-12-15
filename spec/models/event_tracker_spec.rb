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

  # associations
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :organization }
    it { should have_many :pings }
    it { should have_many :contacts }
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

  describe :next_check_at do
    it 'is nil when last_checked_at is nil' do
      t1 = FactoryGirl.create(:event_tracker, last_checked_at: nil)
      expect(t1.next_check_at).to be_nil
    end

    it 'is 1 hour after last_checked_at when hourly' do
      tm = Time.zone.now
      t1 = FactoryGirl.create(:event_tracker, interval_cd: EventTracker.interval(:hourly).id, last_checked_at: tm)
      expect(t1.next_check_at).to eq (tm + 1.hour)
    end

    it 'is corrected when interval changes' do
      tm = Time.zone.now
      t1 = FactoryGirl.create(:event_tracker, interval_cd: EventTracker.interval(:hourly).id, last_checked_at: tm)
      expect(t1.next_check_at).to eq (tm + 1.hour)
      t1.interval = EventTracker.interval(:daily)
      t1.save
      expect(t1.next_check_at).to eq (tm + 1.day)
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
    it "sets status to ok when recently pinged" do
      t1 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now - 65.minutes)
      t1.ping
      t1.reload
      t1.check(Time.zone.now)
      expect(t1.status.name).to eq :ok
    end

    it "reports false when not recently pinged" do
      FactoryGirl.create(:user)
      t1 = FactoryGirl.create(:event_tracker, next_check_at: Time.zone.now - 65.minutes, last_ping_at: Time.zone.now - 90.minutes)
      t1.status = EventTracker.status(:ok)
      t1.check(Time.zone.now)
      expect(t1.status.name).to eq :alert
    end
  end

  describe "contacts" do
    it "requires at least one user_id" do
      FactoryGirl.create(:user)
      t1 = FactoryGirl.build(:event_tracker, contact_user_ids: [])
      expect(t1).to_not be_valid
    end

    it "adds a user when appropriate" do
      u = FactoryGirl.create(:user)
      u2 = FactoryGirl.create(:contact_user, organization: u.organization)
      t1 = FactoryGirl.create(:event_tracker, contact_user_ids: [1])
      t1.contact_user_ids = [1, u2.id]
      t1.save
      expect(t1.contacts.size).to eq 2
    end

    it "removes a user when appropriate" do
      u = FactoryGirl.create(:user)
      u2 = FactoryGirl.create(:contact_user, organization: u.organization)
      t1 = FactoryGirl.create(:event_tracker, contact_user_ids: [1, u2.id])
      t1.contact_user_ids = [1]
      t1.save
      t1.reload
      expect(t1.contacts.size).to eq 1
    end
  end

end
