require 'rails_helper'

feature 'task management' do

  describe "non-logged-in user" do
    it "cannot view tasks page" do
      visit tasks_path
      expect(page).to have_title "Sign In - #{AppConfig.site_name}"
    end
  end

  describe "logged-in user" do
    let!(:user) { sign_in_existing_user }

    scenario 'sees tasks page' do
      visit root_path
      click_on  'Tasks'
      expect(page).to have_title "Tasks"
      expect(page).to have_css 'h1', text: "Tasks"
    end

    scenario 'can add the first task category', js: true do
      visit tasks_path
      click_on "Add a category"
      fill_in "Name", with: "cat1"
      check 'Share with all people in this organization'
      click_on 'Save'
      expect(page).to have_css 'li.task-category', text: 'cat1'
    end

    scenario 'can view tasks in a category', js: true do
      cat = FactoryGirl.create(:task_category, user: user,
        organization: user.organization, name: "cat 1")
      FactoryGirl.create(:task, user: user, task_category: cat, title: "task 1")
      visit tasks_path
      click_on "cat 1"
      expect(page).to have_css 'li.task', text: 'task 1'
    end

   end

end
