require "listen"

listener = Listen.to(Meali::Application.config.menu_root) do |modified, added, removed|
  added.each do |item|
    Meal.convert(item) if File.extname(item.to_s) == ".xlsx"
  end

  modified.each do |item|
    Meal.convert(item) if File.extname(item.to_s) == ".xlsx"
  end
end

listener.start
