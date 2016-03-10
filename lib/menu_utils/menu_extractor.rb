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
      str_dates = @header.select{ |e| e =~ /[0-9]+\/[0-9]+/ }
      dates     = str_dates.map{ |d| Date.new(Date.today.year, d.split("/")[0].to_i, d.split("/")[1].to_i) }
      menu      = []

      str_dates.each do |str_d|
        menu << [@csv.by_col[@header.index(str_d)].to_a, @csv.by_col[@header.index(str_d) + 2].to_a].transpose
        # menu << [@csv[@header.index(str_d)].to_a.flatten, @csv[@header.index(str_d)+2].to_a.flatten]
      end
      p menu
      # dates&.each_with_index do |date, i|
      #   # @csv[str_dates[i]].each do |row|
      #   @csv[str_dates[i]].drop_while{ |row| non_nutrient? row }
      #   meal = Meal.new
      #   meal.served_on = date
      #   p meal
      # end
    end

    # def initialize(menu)
    #   super
    #   daily_menu = csv[date].drop_while{|e| e != date}
    #   meal = Meal.new
    # end

    private
    def non_nutrition? str
      !(str =~ /[0-9]+KC/)
    end

    private
    def header
      CSV.read(@csv_path).select{ |e| e.join =~ /(?=.*#{%w(日 月 火 水 木 金 土).join(')(?=.*')})/ }.first
    end
  end
end
