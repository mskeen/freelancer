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

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      flash.now[:notice] = "Your password has been updated."
      sign_in @user, bypass: true
    end
    render "edit"
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation, :current_password,
      organization_attributes: [:name, :id]
    )
  end
end
