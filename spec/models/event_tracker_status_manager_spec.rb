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
    expect { mgr.change_to_status(EventTracker.status(:alert)) }.to raise_error 'InvalidEventTrackerStatusChange'
  end

  it 'cannot go from ok to peding' do
    mgr = setup_with_status(:ok)
    expect { mgr.change_to_status(EventTracker.status(:pending)) }.to raise_error 'InvalidEventTrackerStatusChange'
  end
end

def setup_with_status(old_status)
  EventTrackerStatusManager.new(
    FactoryGirl.build(:event_tracker, status: EventTracker.status(old_status))
  )
end
