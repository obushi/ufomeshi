require 'csv'
require 'json'

module MenuUtils
  class Extractor
    attr_reader :csv_path, :csv_header, :csv, :ranges

    def initialize(path)
      @csv_path    = path
      @csv_header  = header
      @csv         = CSV.read(@csv_path, {headers: header})
      @ranges      = menu_ranges
    end

    def ranges_of date
      daily_meal_at = @ranges.select{ |r| @csv.by_col[date][r].join.include?("KC") }
    end

    def value_of(nutrient, nutrient_type)
      case nutrient_type
      when :calorie;      nutrient[/(\d+)KC/, 1].to_i
      when :protein;      nutrient[/た(\d+)/, 1].to_i
      when :fat;          nutrient[/脂(\d+)/, 1].to_i
      when :carbohydrate; nutrient[/炭(\d+)/, 1].to_i
      when :salt;         nutrient[/塩(\d+\.\d+)/, 1].to_f
      else; nil
      end
    end

    def nutrient_of(date, range)
      daily_dishes = daily_dishes_of(date)
      daily_dishes[0][range].select{ |menu| menu =~ /\d+KC.*た\d+.*脂\d+.*炭\d+.*塩\d+\.\d+/ }.first
    end

    def dishes_of(date, range)
      daily_dishes = daily_dishes_of(date)
      [daily_dishes[0][range], daily_dishes[1][range]].transpose.select{ |menu| menu[1] =~ /\d+KC/ }
    end

    private
    def header
      week_days = %w(日 月 火 水 木 金 土)
      CSV.read(@csv_path).select{ |e| e.join =~ include_all?(week_days) }.first
    end

    def menu_ranges
      head   = []
      ranges = []
      meal_types = %w(朝 昼 夕)
      @csv.to_a.transpose.select{ |e| e.join =~ include_all?(meal_types) }.first&.each_with_index do |m, i|
        head << i-1 if m =~ /.*[[朝|昼|夕].*食]|合.*計.*/
      end
      head.each_cons(2) do |arr|
        ranges << Range.new(arr[0], arr[1]-1)
      end
      ranges
    end

    def include_all? arr
      /(?=.*#{arr.join(')(?=.*')})/
    end

    def daily_dishes_of date
      [@csv.by_col[@csv_header.index(date)].to_a, @csv.by_col[@csv_header.index(date) + 2].to_a]
    end
  end
end
