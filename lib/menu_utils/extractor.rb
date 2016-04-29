require 'csv'
require 'json'
require_relative "./extractor/helper.rb"

module MenuUtils
  module Extractor
    extend Helper
    def self.create path
      Class.new(Version(path)) do
      end
    end
  end
end
