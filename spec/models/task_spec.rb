require 'rails_helper'

RSpec.describe Task, :type => :model do
  it { should belong_to :user }
  it { should belong_to :completed_by_user }
  it { should belong_to :task_category }
  it { should have_one :spawned_task }

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

    it 'requires weight' do
      expect(FactoryGirl.build(:task, weight: nil)).to_not be_valid
    end

    it 'requires frequency' do
      expect(FactoryGirl.build(:task, frequency_cd: nil)).to_not be_valid
    end
  end

  describe 'default_scope' do
    it 'only includes items that are active' do
      task1 = FactoryGirl.create(:task)
      task2 = FactoryGirl.create(:task, id: 2, is_active: false)
      expect(Task.incomplete).to include task1
      expect(Task.incomplete).to_not include task2
    end
  end

  describe 'incomplete' do
    it 'only includes items that haven''t been completed' do
      task1 = FactoryGirl.create(:task)
      task2 = FactoryGirl.create(:task, id: 2, completed_at: Time.zone.now)
      expect(Task.incomplete).to include task1
      expect(Task.incomplete).to_not include task2
    end
  end

  describe 'complete!' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @task = FactoryGirl.create(:task, user: @user)
    end

    it 'marks the task as done' do
      @task.complete!(@user)
      expect(@task.completed_by_user).to eq @user
      expect(@task.completed_at).to_not be_nil
    end

    it 'marks the task as complete? = true' do
      expect(@task).to_not be_complete
      @task.complete!(@user)
      expect(@task).to be_complete
    end

    it 'assigns the task to the user''s completed list' do
      @task.complete!(@user)
      expect(@user.completed_tasks.size).to eq 1
    end

    it 'can only be completed if incomplete' do
      @task.complete!(@user)
      expect { @task.complete!(@user) }.to(
        raise_error 'AlreadyCompleteError'
      )
    end

    it 'doesn''t spawn a new task if no-repeat' do
      @task.update_attribute(:frequency_cd, Task.frequency(:none).id)
      @task.complete!(@user)
      expect(@task.spawned_task).to be_nil
    end

    it 'spawns a new task when weekly' do
      @task.update_attribute(:frequency_cd, Task.frequency(:weekly).id)
      @task.update_attribute(:reminder_sent_at, Time.zone.now)
      @task.complete!(@user)
      expect(@task.spawned_task).to_not be_nil
      expect(@task.spawned_task.completed_at).to be_nil
      expect(@task.spawned_task.user).to eq @task.user
      expect(@task.spawned_task.reminder_sent_at).to be_nil
    end

  end

  describe 'undo_completion!' do
    before(:each) do
      @user = FactoryGirl.create(:user)
      @task = FactoryGirl.create(:task,
        user: @user, completed_at: Time.zone.now, completed_by_user: @user
      )
    end

    it 'marks the task as incomplete' do
      @task.undo_completion!
      expect(@task.completed_by_user).to be_nil
      expect(@task.completed_at).to be_nil
    end

    it 'can only be undone if complete' do
      @task.undo_completion!
      expect { @task.undo_completion! }.to(
        raise_error 'NotCompleteError'
      )
    end
  end

end
