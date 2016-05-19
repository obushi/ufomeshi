require_relative "./versions/v2015.rb"
require_relative "./versions/v2016.rb"
require_relative "./versions/v2016may.rb"

module Helper
  def version(path)
    if Regexp.union("週間献立表", "KC") === CSV.read(path).to_a.join
      V2015.new(path)
    elsif Regexp.union("表示", "エネルギー") === CSV.read(path).to_a.join
      V2016MAY.new(path)
    else
      V2016.new(path)
    end
  end
end
