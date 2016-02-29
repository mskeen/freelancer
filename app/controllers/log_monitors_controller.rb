class LogMonitorsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  before_action :set_site
  before_action :set_log_monitor, only: [:show, :destroy]

  def show
    respond_with(@log_monitor)
  end

  def new
    @log_monitor = current_user.log_monitors.create(
      site: @site,
      status: LogMonitor.status(:pending)
    )
    redirect_to [@site, @log_monitor]
  end

  def destroy
    # @site.update_attributes(is_deleted: true)
    # respond_with(@site, location: sites_path)
  end

  private

  def set_site
    @site = current_user.sites.active.find_by_token!(params[:site_id])
  end

  def set_log_monitor
    @log_monitor = @site.log_monitors.find(params[:id])
  end

  def site_params
    params.require(:site).permit(
      :name, :url, :host, :log_location, :interval_cd,
      contact_user_ids: []
    )
  end
end
