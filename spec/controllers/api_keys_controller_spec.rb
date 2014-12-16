require 'rails_helper'

RSpec.describe ApiKeysController, type: :controller do

  describe "DELETE destroy" do
    it "fails for another user's api key" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      contact = FactoryGirl.create(:contact_user, organization: user.organization)
      user.confirm!
      contact.confirm!
      sign_in contact

      key = FactoryGirl.create(:api_key, user: user, organization: user.organization)
      xhr :delete, :destroy, id: key
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
