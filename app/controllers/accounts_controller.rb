class AccountsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  def edit
  end

  def update
  end
end
