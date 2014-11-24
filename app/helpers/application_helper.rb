module ApplicationHelper
  def title(page_title)
    provide(:title) do
      if page_title.empty?
        Rails.application.secrets.site_name
      else
        "#{page_title} - #{Rails.application.secrets.site_name}"
      end
    end
  end
end
