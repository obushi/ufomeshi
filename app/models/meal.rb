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
      menu.ranges_of(date).each do |range|
        daily_nutrient = menu.nutrient_of(date, range)
        daily_dishes   = menu.dishes_of(  date, range)

        d = Date.new(Date.today.year, date.split("/")[0].to_i, date.split("/")[1].to_i)
        t = menu.ranges.index(range)

        meal              = Meal.where(served_on: d, meal_type: t).first_or_initialize
        meal.calorie      = menu.value_of(daily_nutrient, :calorie      )
        meal.protein      = menu.value_of(daily_nutrient, :protein      )
        meal.fat          = menu.value_of(daily_nutrient, :fat          )
        meal.carbohydrate = menu.value_of(daily_nutrient, :carbohydrate )
        meal.salt         = menu.value_of(daily_nutrient, :salt         )
        meal.save

        daily_dishes.each do |daily_dish|
          dish = Dish.where(name:    daily_dish[0].gsub(/(\s|　)+/, ""),
                            calorie: daily_dish[1][/(\d+)KC/, 1],
                            meal:    meal ).first_or_create
        end
      end
    end
  end
end
