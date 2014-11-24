# ApplicationHelper
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

  def heading(page_heading, header_class = nil)
    provide(:heading) do
      unless page_heading.empty?
        content_tag(:h1, class: header_class) do
          page_heading
        end
      end
    end
  end
end
