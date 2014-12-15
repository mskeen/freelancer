require 'rails_helper'

RSpec.describe ApiKey, :type => :model do
  it { should belong_to :organization }
  it { should belong_to :user }

  describe 'validations' do
    it 'requires a user' do
      key = FactoryGirl.build(:api_key, user: nil)
      expect(key).to_not be_valid
    end

    it 'requires an organization' do
      key = FactoryGirl.build(:api_key, organization: nil)
      expect(key).to_not be_valid
    end

  end

  describe 'token' do
    it 'is generated when record is created' do
      key = FactoryGirl.create(:api_key)
      expect(key.token.length).to eq ApiKey::TOKEN_LENGTH
    end
  end

  describe 'scopes' do
    it 'only shows activekeys for default scope' do
      user = FactoryGirl.create(:user)
      key1 = FactoryGirl.create(:api_key, user: user)
      key2 = FactoryGirl.create(:api_key, id: 2, user: user, is_active: false)
      expect(user.api_keys).to include key1
      expect(user.api_keys).to_not include key2
    end
  end

end
