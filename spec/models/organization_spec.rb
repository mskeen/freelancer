require 'rails_helper'

RSpec.describe Organization, :type => :model do

  describe Organization, 'name' do
    it 'cannot be blank' do
      org = FactoryGirl.build(:organization, name: '')
      expect(org).to_not be_valid
      expect(org.errors[:name]).to include("can't be blank")
    end
  end

end
