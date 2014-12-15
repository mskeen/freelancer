class ApiKeysController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js

  def create
    @api_key = current_user.api_keys.create(
      organization: current_user.organization
    )
  end

  def destroy
    @api_key = current_user.organization.api_keys.find(params[:id])
    if @api_key.user == current_user || current_user.admin?
      @api_key.update_attribute(:is_active, false)
    else
      render nothing: true, status: :unauthorized
    end
  end

end
