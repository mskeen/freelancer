class LogIpsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :js

  def show
    @log_ip = LogIp[params[:id]]
  end

end
