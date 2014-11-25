require 'rails_helper'

RSpec.describe User, :type => :model do

  describe User, 'name' do
    it 'cannot be blank' do
      user = FactoryGirl.build(:user)
      user.name = nil
      expect(user).to_not be_valid
      expect(user.errors[:name]).to include("can't be blank")
    end
  end
end
