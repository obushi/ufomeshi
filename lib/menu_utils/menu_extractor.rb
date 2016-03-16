require 'csv'
require 'json'

module MenuUtils
  class MenuExtractor
    Breakfast = 0
    Lunch     = 1
    Dinner    = 2

    def initialize(path)
      @csv_path    = path
      @csv_header  = header
      @csv         = CSV.read(@csv_path, {headers: header})
      @meal_header = meal_head
    end

    def extract
      dates_str = @csv_header.select{ |e| e =~ /\d+\/\d+/ }
      dates     = dates_str.map{ |d| Date.new(Date.today.year, d.split("/")[0].to_i, d.split("/")[1].to_i) }
      menu      = []

      dates_str.each do |date_str|
        menu << [@csv.by_col[@csv_header.index(date_str)].to_a, @csv.by_col[@csv_header.index(date_str) + 2].to_a].transpose.reject{ |e| e.include?(nil) }
        daily_meal_at? date_str
      end
      p menu
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

    def daily_meal_at? date_str
      daily_meal_at = []
      @meal_header[Breakfast..Dinner].each_with_index do |h, i|
        menu_first = @meal_header[i]
        menu_last  = @meal_header[i+1]-1 # 最後のメニュー = 次の食事が始まるひとつ前のメニュー
        if @csv.by_col[date_str][Range.new(menu_first, menu_last)].join.include?("KC")
          daily_meal_at << i
        end
      end
      daily_meal_at
    end

    def collect_dishes daily_menu
      dishes = []
      daily_menu.each do |d|
        dishes << [d[0].gsub(/(\s|　)+/, ""), d[1].gsub(/\D+/, "")] if d[1] =~ /\d+KC/
      end
      dishes
    end
  end
end
