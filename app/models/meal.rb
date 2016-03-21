class Meal < ApplicationRecord
  has_many :dishes
  enum meal_type: %w{breakfast lunch dinner}

  # 現在から先の献立
  scope :from_now, -> { where('date >= ?', Date.today) }

  def self.convert(path)
    begin
      Roo::Excelx.new(path).to_csv(path+".csv")
      menu_data = MenuUtils::Extractor.new(path+".csv")
      register(menu_data)
    rescue => e
      raise "献立ファイルの登録に失敗しました。\n#{e.message}"
      logger.fatal "Time: #{Time.now}, Message: #{e.message}"
    end
  end

  def self.register(menu)
    dates = menu.csv_header.select{ |e| e =~ /\d+\/\d+/ }
    dates.each do |date|
      daily_dishes = menu.daily_dishes_of(date)
      menu.dish_ranges_of(date).each do |dish_range|
        nutrient = daily_dishes[0][dish_range].select{ |menu| menu =~ /\d+KC.*た\d+.*脂\d+.*炭\d+.*塩\d+\.\d+/ }.first
        dishes = [daily_dishes[0][dish_range], daily_dishes[1][dish_range]].transpose.select{ |menu| menu[1] =~ /\d+KC/ }
        
        meal              = Meal.new
        meal.served_on    = Date.new(Date.today.year, date.split("/")[0].to_i, date.split("/")[1].to_i)
        meal.meal_type    = menu.meal_header.index(dish_range)
        meal.calorie      = menu.nutrient_of(:calorie,      nutrient)
        meal.protein      = menu.nutrient_of(:protein,      nutrient)
        meal.fat          = menu.nutrient_of(:fat,          nutrient)
        meal.carbohydrate = menu.nutrient_of(:carbohydrate, nutrient)
        meal.salt         = menu.nutrient_of(:salt,         nutrient)
        p meal
      end
    end
  end
end
