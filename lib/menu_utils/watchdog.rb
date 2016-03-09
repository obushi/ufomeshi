require 'csv'
require 'json'
require 'fssm'

module MenuUtils
  class Watchdog
    def initialize(path, type)
      FSSM.monitor(path, "**/*.#{type}") do
        create do |base, file|
          p "##############################"
          p "#{base}/#{file}"
        end
      end
    end
  end
end
