require 'csv'
require 'json'

module MenuUtils
  class Extractor
    attr_reader :csv_path, :csv_header, :csv, :meal_header

    Breakfast = 0
    Lunch     = 1
    Dinner    = 2

    def initialize(path)
      @csv_path    = path
      @csv_header  = header
      @csv         = CSV.read(@csv_path, {headers: header})
      @meal_header = meal_head
    end

    def daily_dishes_of date
      [@csv.by_col[@csv_header.index(date)].to_a, @csv.by_col[@csv_header.index(date) + 2].to_a]
    end

    def dish_ranges_of date
      daily_meal_at = []
      @meal_header[Breakfast..Dinner].each_with_index do |h, i|
        menu_first = @meal_header[i]
        menu_last  = @meal_header[i+1]-1 # 最後のメニュー = 次の食事が始まるひとつ前のメニュー
        if @csv.by_col[date][Range.new(menu_first, menu_last)].join.include?("KC")
          daily_meal_at << Range.new(menu_first, menu_last)
        end
      end
      daily_meal_at
    end

    def nutrient_of(nutrient_type, nutrient)
      case nutrient_type
      when :calorie;      nutrient[/(\d+)KC/, 1].to_i
      when :protein;      nutrient[/た(\d+)/, 1].to_i
      when :fat;          nutrient[/脂(\d+)/, 1].to_i
      when :carbohydrate; nutrient[/炭(\d+)/, 1].to_i
      when :salt;         nutrient[/塩(\d+\.\d+)/, 1].to_f
      else; nil
      end
    end

    private
    def header
      week_days = %w(日 月 火 水 木 金 土)
      CSV.read(@csv_path).select{ |e| e.join =~ include_all?(week_days) }.first
    end

    def meal_head
      head = []
      meal_types = %w(朝 昼 夕)
      @csv.to_a.transpose.select{ |e| e.join =~ include_all?(meal_types) }.first&.each_with_index do |m, i|
        head << i-1 if m =~ /.*[[朝|昼|夕].*食]|合.*計.*/
      end
      head
    end

    def include_all? arr
      /(?=.*#{arr.join(')(?=.*')})/
    end
  end
end
