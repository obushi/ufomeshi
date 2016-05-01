module ApplicationHelper
  def prev_date_button(prev_meal)
    if prev_meal[:exists?]
      link_to meal_path(prev_meal[:date].strftime("%Y%m%d")), title: l(prev_meal[:date], format: :long)+"の献立", class: "uk-button" do
        content_tag("i", "", class:"uk-icon-chevron-left")
      end
    else
      button_tag({disabled: true, class: "uk-button", type: "button"}) do
        content_tag("i", "", class:"uk-icon-chevron-left")
      end
    end
  end

  def next_date_button(next_meal)
    if next_meal[:exists?]
      link_to meal_path(next_meal[:date].strftime("%Y%m%d")), title: l(next_meal[:date], format: :long)+"の献立", class: "uk-button" do
        content_tag("i", "", class:"uk-icon-chevron-right")
      end
    else
      button_tag({disabled: true, class: "uk-button", type: "button"}) do
        content_tag("i", "", class:"uk-icon-chevron-right")
      end
    end
  end
end
