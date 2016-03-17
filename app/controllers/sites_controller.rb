class SitesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html

  before_action :set_site, only: [:show, :edit, :update, :destroy]

  def index
    @sites = current_user.sites.active.all
  end

  def show
    @log_monitors = LogMonitor.find(site_id: @site.token)
    respond_with(@site)
  end

  def new
    @site = Site.new(contact_user_ids: [current_user.id])
    respond_with(@site)
  end

  def edit
  end

  def create
    @site = current_user.sites.new(site_params)
    @site.contact_user_ids = params[:site][:contact_user_ids]
    @site.status = Site.status(:pending)
    @site.is_deleted = false
    @site.organization = current_user.organization
    @site.save
    respond_with(@site)
  end

  def update
    @site.contact_user_ids = params[:site][:contact_user_ids]
    @site.update(site_params)
    respond_with(@site)
  end

  def destroy
    @site.update_attributes(is_deleted: true)
    respond_with(@site, location: sites_path)
  end

  private

  def set_site
    @site = current_user.sites.active.find_by_token!(params[:id])
  end

  def site_params
    params.require(:site).permit(
      :name, :url, :host, :log_location, :interval_cd, :log_filter,
      contact_user_ids: []
    )
  end
end
