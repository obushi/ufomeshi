module ApplicationHelper
  def prev_date_button(prev_meal)
    if prev_meal[:exists?]
      link_to("<<", meal_path(prev_meal[:date].strftime("%Y%m%d")),
              title: l(prev_meal[:date], format: :long)+"の献立",
              class: "uk-button")
    else
      button_tag("<<", {disabled: true, class: "uk-button", type: "button"})
    end
  end

  def next_date_button(next_meal)
    if next_meal[:exists?]
      link_to(">>", meal_path(next_meal[:date].strftime("%Y%m%d")),
              title: l(next_meal[:date], format: :long)+"の献立",
              class: "uk-button")
    else
      button_tag(">>", {disabled: true, class: "uk-button", type: "button"})
    end
  end
end
