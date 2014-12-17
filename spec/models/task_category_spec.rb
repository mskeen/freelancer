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

end
