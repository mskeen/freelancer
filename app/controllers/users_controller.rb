class UsersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_user, only: [:edit, :update, :destroy]

  respond_to :html, :js

  def index
    @users = current_user.organization.users
  end

  def new
    @user = current_user.organization.users.new(role: User.role(:contact))
  end

  def edit
    render :new
  end

  def create
    @user = current_user.organization.users.new(user_params)
    @user.creator = current_user
    UserCreator.new(@user).create
    respond_with(@user)
  end

  def update
    @user.update(user_params)
    @users = current_user.organization.users
  end

  def destroy
    @user.update_attributes(is_active: false)
    respond_with(@user, location: users_path)
  end

  private

  def set_user
    @user = current_user.organization.users.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role_cd, :is_invited)
  end

end
