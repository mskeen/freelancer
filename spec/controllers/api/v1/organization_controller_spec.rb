require 'rails_helper'

RSpec.describe Api::V1::OrganizationController, type: :controller do
  before(:each) do
    request.env["HTTP_ACCEPT"] = 'application/json'
    @user = FactoryGirl.create(:user)
    @key = FactoryGirl.create(:api_key, user: @user, organization: @user.organization)
  end



  describe "GET show" do

    describe "unauthorized request" do
      it "fails when key is invalid" do
        get :show, { "HTTP_AUTHORIZATION" => 'Token token="abc"' }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "authorized_request" do
      before(:each) { set_auth_header }

      it "fails when rate limit exceeded" do
        @key.update_attribute(:hourly_rate_limit, 1)
        get :show
        expect(response).to have_http_status(:success)
        get :show
        expect(response).to have_http_status(:too_many_requests)
      end

      it "returns the organization details" do
        get :show
        expect(response).to have_http_status(:success)
      end
    end

  end

  describe "PUT update" do
    before(:each) { set_auth_header }

    it "updates the organization" do
      put :update, {organization: { name: 'updated' }}
      expect(response).to have_http_status(:success)
      @user.organization.reload
      expect(@user.organization.name).to eq "updated"
    end

    it "fails if user is not admin" do
      @user.role = User.role(:contact)
      @user.save
      put :update, {organization: { name: 'updated' }}
      expect(response).to have_http_status(:unauthorized)
    end
  end


  def set_auth_header
    controller.request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(@key.token)
  end

end
