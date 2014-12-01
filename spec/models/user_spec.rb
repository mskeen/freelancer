require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many :event_trackers }
  it { should belong_to :organization }

  describe User, 'Name' do
    it 'cannot have a blank name' do
      user = User.new(name: nil)
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end
end
