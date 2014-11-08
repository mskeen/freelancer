module ApplicationHelper
  def title(page_title)
    provide(:title) do
      if page_title.empty?
        APP_CONFIG['site_name']
      else
        "#{page_title} - #{APP_CONFIG['site_name']}"
      end
    end
  end
end
