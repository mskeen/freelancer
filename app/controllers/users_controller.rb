class UsersController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  def index
    @users = current_user.organization.users
  end

  def new
    @user = current_user.organization.users.new(role: User.role(:contact))
  end

  def create
    @user = current_user.organization.users.new(user_params)
    @user.save
    respond_with(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :role_cd)
  end

end
