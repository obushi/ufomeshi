require 'roo'
require 'csv'
require 'json'

module MenuUtils
  class FileImporter
    attr_reader :path, :csv

    def initialize(source_path)
      @path = source_path
    end

    def to_csv
      begin
        # p Roo::Excelx.new(@path).sheets.first
        @csv = Roo::Excelx.new(@path).to_csv
      rescue => e
        raise "ファイルの変換に失敗しました。\n#{e.message}"
        logger.fatal "Time: #{Time.now}, Message: #{e.message}"
      end
    end
  end
end
