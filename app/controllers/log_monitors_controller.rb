class LogMonitorsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :js

  before_action :set_site
  before_action :set_log_monitor, only: [:show, :destroy, :cancel]

  def show
  end

  def new
    @log_monitor = LogMonitor.create(
      created_at: Time.now.to_s(:db),
      log_type: (params[:type] || "cat"),
      log_filter: @site.log_filter,
      site_id: @site.token,
      status: "pending"
    )
    LogMonitorWorker.perform_async(@log_monitor.id)
    redirect_to site_log_monitor_path(@site.token, @log_monitor.id)
  end

  def cancel
    @log_monitor.update(status: "cancelled")
    render :show
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
    @log_monitor = LogMonitor[params[:id]]
  end

  def site_params
    params.require(:site).permit(
      :name, :url, :host, :log_location, :interval_cd,
      contact_user_ids: []
    )
  end
end
