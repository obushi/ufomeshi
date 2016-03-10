listener = Listen.to(Meali::Application.config.menu_root) do |modified, added, removed|
  MenuUtils::MenuExtractor.new(added.first).extract if File.extname(added.first.to_s) == ".csv"
end

listener.start
