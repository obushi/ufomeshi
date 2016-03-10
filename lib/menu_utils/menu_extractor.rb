require 'csv'
require 'json'

module MenuUtils
  class MenuExtractor
    def initialize(path)
      @csv_path   = path
      @header     = header
      @csv        = CSV.read(@csv_path, {headers: header})
    end

    def extract
      dates = @header.select{ |e| e =~ /[0-9]+\/[0-9]+/ }
      dates.each do |date|
        Meal.new(@csv, date)
      end
    end

    private
    def header
      CSV.read(@csv_path).select{ |e| e.join =~ /(?=.*#{%w(日 月 火 水 木 金 土).join(')(?=.*')})/ }.first
    end
  end
end
