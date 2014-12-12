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

  describe User, 'organization' do
    it "is assigned to the user if role is root" do
      user = FactoryGirl.create(:user)
      expect(user.organization.user).to eq user
    end

    it 'is not assigned to a new user if it''s not a root user' do
      root_user = FactoryGirl.create(:user)
      contact_user = FactoryGirl.create(:contact_user, organization: root_user.organization)
      expect(contact_user.organization.user).to eq root_user
    end
  end
end
