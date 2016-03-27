require 'test_helper'

class DishTest < ActiveSupport::TestCase
  test "should save dish" do
    dish = Dish.new(name: "献立", calorie: 120)
    assert dish.save
  end
end
