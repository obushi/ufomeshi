class Meal < ApplicationRecord
  has_many :dishes
  accepts_nested_attributes_for :dishes

  enum meal_type: %w{breakfast lunch dinner}

  # 必須かつ一意
  validates :served_on, :meal_type, presence: true
  validates_uniqueness_of :served_on, scope: :meal_type

  # 自然数
  validates :calorie, :protein, :fat, :carbohydrate, numericality: { only_integer: true, greater_than_or_equal_to: 1 }, allow_nil: true

  # 正の小数
  validates :salt, numericality: { greater_than_or_equal_to: 0.1 }

  validates_associated :dishes

  scope :from_now, ->        { where("served_on >= ?", Date.today) }   # 現在から先の献立
  scope :since_year_ago, ->  { where("served_on >= ?", 1.year.ago) }   # 1年前から現在の献立
  scope :daily,    -> (date) { where(served_on: date) }
  scope :today,    ->        { where(served_on: Date.today) }

  def self.prev(date)
    prev_meal = Meal.where("served_on < ?", date).order(served_on: :desc).first
    { date: prev_meal&.served_on, exists?: Meal.exists?(prev_meal&.id) }
  end

  def self.next(date)
    next_meal = Meal.where("served_on > ?", date).order(served_on: :asc).first
    { date: next_meal&.served_on, exists?: Meal.exists?(next_meal&.id) }
  end

  def self.forecast(date)
    date.beginning_of_week(:sunday)..date.end_of_week(:sunday) if date.present?
  end

  def self.convert(path)
    convert_status = ConvertStatus.new(
      file_name:   File::basename(path),
      uploaded_at: Time.now)
    begin
      Roo::Excelx.new(path).to_csv(path+".csv")
      menu = MenuUtils::Extractor::open(path+".csv")
      register(menu)

      # 例外が発生せず、成功したときは 献立の開始・終了日およびステータス：正常 を記録
      convert_status.start_on = menu.to_date(menu.meal_dates.first)
      convert_status.end_on   = menu.to_date(menu.meal_dates.last)
      convert_status.status   = 0
    rescue => e
      # 例外が発生したので 変換のステータス：異常 を記録
      convert_status.status   = 1
      logger.error "Time: #{Time.now}, Message: #{e.message}\n#{e.backtrace.join("\n")}"
    ensure
      convert_status.save
    end
  end

  def self.register(menu)
    raise "献立ファイルが不正です。" unless menu.valid?

    menu.meal_dates.each do |date|
      menu.meals_on(date).each do |meal|
        meal_nutrients  = menu.nutrients_of(date, meal)
        meal_dishes     = menu.dishes_of(date, meal)

        params = {
          served_on:    menu.to_date(date),
          meal_type:    menu.dish_ranges.index(meal),
          calorie:      menu.value_of(meal_nutrients, :calorie      ),
          protein:      menu.value_of(meal_nutrients, :protein      ),
          fat:          menu.value_of(meal_nutrients, :fat          ),
          carbohydrate: menu.value_of(meal_nutrients, :carbohydrate ),
          salt:         menu.value_of(meal_nutrients, :salt         ),

          dishes_attributes:
            meal_dishes.map { |dish| { name: dish[0],
                                       calorie: dish[1] }}
        }

        meal = Meal.create(params)
      end
    end
  end
end
