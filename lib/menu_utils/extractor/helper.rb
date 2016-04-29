require_relative "./versions/v2015.rb"
require_relative "./versions/v2016.rb"

module Helper
  def Version(path)
    if Regexp.union("週間献立表", "KC") =~ CSV.read(path).to_a.join
      Class.new do
        String.send(:include, V2015::DateFormatter)
        include V2015::Base
      end
    else
      Class.new do
        String.send(:include, V2016::DateFormatter)
        include V2016::Base
      end
    end
  end
end
