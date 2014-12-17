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

    it 'sees tasks page' do
      visit root_path
      click_on  'Tasks'
      expect(page).to have_title "Tasks - #{AppConfig.site_name}"
      expect(page).to have_css 'h1', text: "Tasks"
    end
   end

end
