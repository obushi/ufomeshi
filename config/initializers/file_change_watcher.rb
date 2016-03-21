listener = Listen.to(Meali::Application.config.menu_root) do |modified, added, removed|
  Meal.convert(added.first) if File.extname(added.first.to_s) == ".xlsx"
end

listener.start
