class AccountsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def edit
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = "Your changes have been saved."
    end
    respond_with current_user, location: edit_account_path
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, organization_attributes: [:name]
    )
  end

end
