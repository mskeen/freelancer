require 'rails_helper'

RSpec.describe Contact, :type => :model do

  # associations
  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :alertable }
  end

  it "delegate email to the user" do
    user = FactoryGirl.build(:user)
    contact = FactoryGirl.build(:contact, user: user)
    expect(contact.email).to eq user.email
  end
end
