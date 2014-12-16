class ApiKeysController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_api_key, only: [:edit, :update, :destroy]

  respond_to :js

  def create
    @api_key = current_user.api_keys.create(
      organization: current_user.organization
    )
  end

  def edit
  end

  def update
    @api_key.update_attributes(api_key_params)
  end

  def destroy
    if @api_key.user == current_user || current_user.admin?
      @api_key.update_attribute(:is_active, false)
    else
      render nothing: true, status: :unauthorized
    end
  end

  private

  def api_key_params
    params.require(:api_key).permit(:hourly_rate_limit, :user_id)
  end

  def set_api_key
    @api_key = current_user.organization.api_keys.find(params[:id])
  end

end
