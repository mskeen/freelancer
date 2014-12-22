module TasksHelper

  def display_weight(weight)
    "<span class=\"label #{weight_to_label_class(weight)}\">#{weight}</span>"
      .html_safe
  end

  private

  def weight_to_label_class(weight)
    case weight
    when 1 then 'label-primary'
    when 2 then 'label-success'
    when 5 then 'label-warning'
    else 'label-danger'
    end
  end

end
