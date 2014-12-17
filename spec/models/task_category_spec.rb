require 'rails_helper'

RSpec.describe TaskCategory, :type => :model do
  it { should belong_to :user }
  it { should belong_to :organization }
  it { should have_many :tasks }

  describe "defaults" do
    scenario "is_shared is false" do
      expect(TaskCategory.new.is_shared).to be false
    end
    scenario "is_active is false" do
      expect(TaskCategory.new.is_active).to be true
    end
  end

  describe 'validation' do
    it 'passed when all fields present' do
      expect(FactoryGirl.build(:task_category)).to be_valid
    end

    it 'requires name' do
      expect(FactoryGirl.build(:task_category, name: nil)).to_not be_valid
    end
  end

  describe 'for_user' do
    it "returns all categories owned by user or shared by an admin" do
      user = FactoryGirl.create(:user, is_active: false)
      user2 = FactoryGirl.create(:user, id: 2, organization: user.organization, email: "e2@sample.com", is_active: true)
      cat1 = FactoryGirl.create(:task_category, user: user)
      cat2 = FactoryGirl.create(:task_category, id: 2, user: user2, is_shared: true)
      cat3 = FactoryGirl.create(:task_category, id: 3, user: user2, is_shared: false)
      cats = TaskCategory.for_user(user)
      expect(cats).to include cat1
      expect(cats).to include cat2
      expect(cats).to_not include cat3
    end
  end

end
