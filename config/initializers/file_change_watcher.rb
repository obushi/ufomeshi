require "listen"

listener = Listen.to(Meali::Application.config.menu_root, only: /\.xlsx$/) do |modified, added, removed|
  added.each do |item|
    Meal.convert(item)
  end

  modified.each do |item|
    Meal.convert(item)
  end
end

listener.start
