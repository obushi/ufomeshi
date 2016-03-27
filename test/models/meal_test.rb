require 'test_helper'

class MealTest < ActiveSupport::TestCase
  test "should save meal" do
    params = {
      served_on: Date.today,
      meal_type: 0,
      calorie: 100,
      protein: 50,
      fat: 10,
      carbohydrate: 20,
      salt: 3.5,
      dishes_attributes: [{name: "食べ物", calorie: 200}, {name: "デザート", calorie: 100}]
    }
    meal = Meal.new(params)
    assert meal.save
  end
end
