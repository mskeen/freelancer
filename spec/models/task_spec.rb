require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to :user }
  it { should belong_to :task_category }

  describe "defaults" do
    scenario "description is blank but not null" do
      expect(Task.new.description).to eq ''
    end
    scenario "is_active is true" do
      expect(Task.new.is_active).to eq true
    end
  end

  describe 'validation' do
    it 'passed when all fields present' do
      expect(FactoryGirl.build(:task)).to be_valid
    end

    it 'requires title' do
      expect(FactoryGirl.build(:task, title: nil)).to_not be_valid
    end

  end

end
