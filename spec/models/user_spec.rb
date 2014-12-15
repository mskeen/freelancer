require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many :event_trackers }
  it { should belong_to :organization }
  it { should belong_to :creator }

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
      expect(user.role).to eq User.role(:root)
    end

    it 'must be in the role list' do
      user = User.new(role_cd: 88)
      expect(user).to_not be_valid
      expect(user.errors[:role_cd].count).to eq 1
    end
  end

  describe User, :admin? do
    it 'is true for root and admin roles' do
      [User.role(:root), User.role(:admin)].each do |role|
        user = User.new(role: role)
        expect(user).to be_admin
      end
    end

    it 'is not true for other roles' do
      [User.role(:contact)].each do |role|
        user = User.new(role: role)
        expect(user).to_not be_admin
      end
    end
  end

  describe User, :root? do
    it 'is true for root role' do
      user = User.new(role: User.role(:root))
      expect(user).to be_root
    end

    it 'is not true for other roles' do
      [User.role(:contact), User.role(:admin)].each do |role|
        user = User.new(role: role)
        expect(user).to_not be_root
      end
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

  describe User, 'scopes' do
    it "default_scope only returns active users" do
      user = FactoryGirl.create(:user, is_active: false)
      user2 = FactoryGirl.create(:user, id: 2, organization: user.organization, email: "e2@sample.com", is_active: true)
      expect(user.organization.users).to include user2
      expect(user.organization.users).to_not include user
    end
  end


end
