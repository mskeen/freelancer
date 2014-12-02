require 'rails_helper'

RSpec.describe EventTrackerPing, type: :model do
  # associations
  describe 'associations' do
    it { should belong_to :event_tracker }
  end

end
