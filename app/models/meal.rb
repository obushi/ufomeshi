class Meal < ApplicationRecord
  has_many :dishes
  accepts_nested_attributes_for :dishes

  enum meal_type: %w{breakfast lunch dinner}

  # 必須かつ一意
  validates :served_on, :meal_type, presence: true
  validates_uniqueness_of :served_on, scope: :meal_type

  # 自然数
  validates :calorie, :protein, :fat, :carbohydrate, numericality: { only_integer: true, greater_than_or_equal_to: 1 }

  # 正の小数
  validates :salt, numericality: { greater_than_or_equal_to: 0.1 }

  validates_associated :dishes

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

        params = {
          served_on:    Date.new(Date.today.year, date.split("/")[0].to_i, date.split("/")[1].to_i),
          meal_type:    menu.ranges.index(range),
          calorie:      menu.value_of(daily_nutrient, :calorie      ),
          protein:      menu.value_of(daily_nutrient, :protein      ),
          fat:          menu.value_of(daily_nutrient, :fat          ),
          carbohydrate: menu.value_of(daily_nutrient, :carbohydrate ),
          salt:         menu.value_of(daily_nutrient, :salt         ),

          dishes_attributes:
            daily_dishes.map { |dish| { name: dish[0].gsub(/(\s|　)+/, ""),
                                        calorie: dish[1][/(\d+)KC/, 1] }}
        }

        meal = Meal.create(params)
      end
    end
  end
end
