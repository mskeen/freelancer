require 'rails_helper'

RSpec.describe Organization, :type => :model do

  it { should belong_to :user }
  it { should have_many :users }
  it { should have_many :event_trackers }
  it { should have_many :api_keys }

  describe Organization, 'Name' do
    it 'cannot have a blank name' do
      org = Organization.new(name: '')
      expect(org).to_not be_valid
      expect(org.errors[:name]).to include("can't be blank")
    end
  end

end
