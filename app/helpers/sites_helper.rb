# SitesHelper
module SitesHelper
  def site_class(site)
    'danger' if site.status == Site.status(:down)
  end
end
