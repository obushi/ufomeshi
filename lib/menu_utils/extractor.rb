require 'csv'
require 'json'
require_relative "./extractor/helper.rb"

module MenuUtils
  module Extractor
    extend Helper
    def self.open path
      version(path)
    end
  end
end
