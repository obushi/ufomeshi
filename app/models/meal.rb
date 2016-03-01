class Meal < ApplicationRecord
  enum meal_type: %w{breakfast lunch dinner}

  has_many :dishes
end
