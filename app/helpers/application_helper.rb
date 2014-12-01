# ApplicationHelper
module ApplicationHelper
  def title(page_title)
    provide(:title) do
      if page_title.empty?
        AppConfig.site_name
      else
        "#{page_title} - #{AppConfig.site_name}"
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

  def current_item_class(controller_list)
    controller_name = controller.class.name.downcase.gsub('controller', '')
    return "class=\"current\"".html_safe if controller_list.include? controller_name
    return ""
  end
end
