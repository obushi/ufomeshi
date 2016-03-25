class Dish < ApplicationRecord
  belongs_to :meal

  validates :name, :calorie, :meal_id, presence: true
  validates :calorie, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
