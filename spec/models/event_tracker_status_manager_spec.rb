require 'rails_helper'

RSpec.describe EventTrackerStatusManager, type: :model do

  it 'can stay the same (pending)' do
    t = build_with_status(:pending)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:pending))).to eq true
    expect(t.status.name).to eq :pending
  end

  it 'can stay the same (ok)' do
    t = build_with_status(:ok)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
    expect(t.status.name).to eq :ok
  end

  it 'can move from pending to ok' do
    t = build_with_status(:pending)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
    expect(t.status.name).to eq :ok
  end

  it 'can move from paused to ok' do
    t = build_with_status(:paused)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
    expect(t.status.name).to eq :ok
  end

  it 'can move from alert to ok' do
    t = build_with_status(:alert)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
    expect(t.status.name).to eq :ok
  end

  it 'can move from ok to alert' do
    t = build_with_status(:ok)
    mgr = EventTrackerStatusManager.new(t)
    expect(mgr.change_to_status(EventTracker.status(:alert))).to eq true
    expect(t.status.name).to eq :alert
  end

  it 'cannot go from pending to alert' do
    t = build_with_status(:pending)
    mgr = EventTrackerStatusManager.new(t)
    expect { mgr.change_to_status(EventTracker.status(:alert)) }.to(
      raise_error 'InvalidEventTrackerStatusChange'
    )
    expect(t.status.name).to eq :pending
  end

  it 'cannot go from ok to pending' do
    t = build_with_status(:ok)
    mgr = EventTrackerStatusManager.new(t)
    expect { mgr.change_to_status(EventTracker.status(:pending)) }.to(
      raise_error 'InvalidEventTrackerStatusChange'
    )
    expect(t.status.name).to eq :ok
  end

  it 'sends an alert email when status changes from ok to alert' do
    t = build_with_status(:ok)
    mgr = EventTrackerStatusManager.new(t)

    expect{mgr.change_to_status EventTracker.status(:alert)}.to(
      change{ ActionMailer::Base.deliveries.size }.by(1)
    )
    expect(ActionMailer::Base.deliveries.last.to).to eq ['test@sample.com']
    expect(ActionMailer::Base.deliveries.last.subject).to eq 'Alert: first event tracker'
  end

  it 'sends an "alert clear" email when status changes from alert to ok' do
    t = build_with_status(:alert)
    mgr = EventTrackerStatusManager.new(t)
    expect{ mgr.change_to_status EventTracker.status(:ok) }.to(
      change{ ActionMailer::Base.deliveries.size }.by(1)
    )
    expect(ActionMailer::Base.deliveries.last.to).to eq ['test@sample.com']
    expect(ActionMailer::Base.deliveries.last.subject).to eq 'Alert Cleared: first event tracker'
  end
end

def build_with_status(old_status)
  FactoryGirl.create(:event_tracker,
                    email: 'test@sample.com',
                    status: EventTracker.status(old_status))
end
