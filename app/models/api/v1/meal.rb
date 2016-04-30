class Api::V1::Meal < Meal
  scope :name_like,-> (name) { where(id: Dish.where('name like ?', "%#{name}%")).since_year_ago }
end
