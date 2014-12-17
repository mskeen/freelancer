require 'rails_helper'

RSpec.describe Api::V1::OrganizationController, type: :controller do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @key = FactoryGirl.create(:api_key, user: @user, organization: @user.organization)
  end

  describe "GET show" do

    it "fails when key is invalid" do
      get :show, { "HTTP_AUTHORIZATION" => 'Token token="' + @key.token + '"' }, format: :json
      expect(response).to have_http_status(:unauthorized)
    end

    it "fails when rate limit exceeded" do
      @key.update_attribute(:hourly_rate_limit, 1)
      get :show, { "HTTP_AUTHORIZATION" => 'Token token="' + @key.token + '"' }, format: :json
      expect(response).to have_http_status(:success)
      get :show, { "HTTP_AUTHORIZATION" => 'Token token="' + @key.token + '"' }, format: :json
      expect(response).to have_http_status(:too_many_requests)
    end

    it "returns the organization details" do
      get :show, id: 1, key: @key.token, format: :json
      expect(response).to have_http_status(:success)
    end

  end

  describe "PUT update" do

    it "updates the organization" do
      put :update, {organization: { name: 'updated' }}, { "HTTP_AUTHORIZATION" => 'Token token="' + @key.token + '"' }, format: :json
      expect(response).to have_http_status(:success)
      expect(@user.organization.name).to eq "updated"
    end

    it "fails if user is not admin" do
      @user.role = User.role(:contact)
      @user.save
      put :update, {organization: { name: 'updated' }}, { "HTTP_AUTHORIZATION" => 'Token token="' + @key.token + '"' }, format: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
