require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many :event_trackers }
  it { should have_many :contacts }
  it { should belong_to :organization }

  describe User, 'name' do
    it 'cannot have a blank name' do
      user = User.new(name: nil)
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end

  describe User, 'role' do
    it 'defaults to "root"' do
      user = User.new
      expect(user.role).to eq User::ROLE_ROOT
    end

    it 'must be in the role list' do
      user = User.new(role: 'happy')
      expect(user).to_not be_valid
      expect(user.errors[:role].count).to eq 1
    end
  end
end
