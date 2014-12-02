require 'rails_helper'

RSpec.describe EventTrackerStatusManager, type: :model do

  it 'can stay the same' do
    mgr = setup_with_status(:pending)
    expect(mgr.change_to_status(EventTracker.status(:pending))).to eq true
    mgr = setup_with_status(:ok)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
  end

  it 'can move from pending to ok' do
    mgr = setup_with_status(:pending)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
  end

  it 'can move from paused to ok' do
    mgr = setup_with_status(:paused)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
  end

  it 'can move from alert to ok' do
    mgr = setup_with_status(:alert)
    expect(mgr.change_to_status(EventTracker.status(:ok))).to eq true
  end

  it 'can move from ok to alert' do
    mgr = setup_with_status(:ok)
    expect(mgr.change_to_status(EventTracker.status(:alert))).to eq true
  end

  it 'cannot go from pending to alert' do
    mgr = setup_with_status(:pending)
    expect { mgr.change_to_status(EventTracker.status(:alert)) }.to(
      raise_error 'InvalidEventTrackerStatusChange'
    )
  end

  it 'cannot go from ok to peding' do
    mgr = setup_with_status(:ok)
    expect { mgr.change_to_status(EventTracker.status(:pending)) }.to(
      raise_error 'InvalidEventTrackerStatusChange'
    )
  end

  it 'sends an alert email when status changes from ok to alert' do
    mgr = setup_with_status(:ok)

    expect{mgr.change_to_status EventTracker.status(:alert)}.to(
      change{ ActionMailer::Base.deliveries.size }.by(1)
    )
    expect(ActionMailer::Base.deliveries.last.to).to eq ['test@sample.com']
    expect(ActionMailer::Base.deliveries.last.subject).to eq 'Alert: first event tracker'
  end

  it 'sends an "alert clear" email when status changes from alert to ok' do
    mgr = setup_with_status(:alert)
    expect{ mgr.change_to_status EventTracker.status(:ok) }.to(
      change{ ActionMailer::Base.deliveries.size }.by(1)
    )
    expect(ActionMailer::Base.deliveries.last.to).to eq ['test@sample.com']
    expect(ActionMailer::Base.deliveries.last.subject).to eq 'Alert Cleared: first event tracker'
  end
end

def setup_with_status(old_status)
  EventTrackerStatusManager.new(
    FactoryGirl.build(:event_tracker,
                      email: 'test@sample.com',
                      status: EventTracker.status(old_status))
  )
end
