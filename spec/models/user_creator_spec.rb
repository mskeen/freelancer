require 'rails_helper'

RSpec.describe UserCreator do

  describe "create" do
    it "saves a valid user" do
      creator = FactoryGirl.create(:user)
      user = FactoryGirl.build(:contact_user, creator: creator, organization: creator.organization)
      UserCreator.new(user).create
      expect(user.new_record?).to eq false
    end

    it "sends an invitation" do
      creator = FactoryGirl.create(:user)
      user = FactoryGirl.build(:contact_user, creator: creator, organization: creator.organization)
      UserCreator.new(user).create
      expect{ UserCreator.new(user).create }.to(
        change{ ActionMailer::Base.deliveries.size }.by(1)
      )
      expect(ActionMailer::Base.deliveries.last.to).to eq ['contact@sample.com']
    end

    it "doesn't save the user if the email fails" do
      allow(MailerUtility).to receive(:try_delivery).and_return(false)
      creator = FactoryGirl.create(:user)
      user = FactoryGirl.build(:contact_user, creator: creator, organization: creator.organization)
      UserCreator.new(user).create
      expect(user.new_record?).to eq false
    end

  end

end
