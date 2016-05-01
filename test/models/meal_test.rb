require 'test_helper'

class MealTest < ActiveSupport::TestCase
  test "should save meal v2015" do
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

  test "should save meal v2016" do
    params = {
      served_on: Date.today,
      meal_type: 0,
      calorie: 100,
      protein: 50,
      fat: 10,
      salt: 3.5,
      dishes_attributes: [{name: "Food", calorie: nil}, {name: "Dessert", calorie: nil}]
    }
    meal = Meal.new(params)
    assert meal.save
  end

  test "should return some meals" do
    meals = Meal.from_now
    assert_instance_of(Meal, meals.first)
  end

  test "should convert excel file v2015" do
    assert Meal.convert("test/fixtures/files/v2015_test.xlsx")
  end

  test "should convert excel file v2016" do
    assert Meal.convert("test/fixtures/files/v2016_test.xlsx")
  end

  test "shoud return range" do
    meal = Meal.first
    assert_instance_of(Range, Meal.forecast(meal.served_on))
  end
end
