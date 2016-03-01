class Meal < ApplicationRecord
  enum meal_type: %w{breakfast lunch dinner}

  # 現在から先の献立
  scope :from_now, -> { where('date >= ?', Date.today)}

  has_many :dishes
end
