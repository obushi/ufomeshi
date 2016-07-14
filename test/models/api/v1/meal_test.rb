require 'test_helper'

class MealTest < ActiveSupport::TestCase
  test "should get some meals" do
    meals = Api::V1::Meal.name_like("ご飯")
    assert_instance_of(Api::V1::Meal, meals.first)
  end
end
