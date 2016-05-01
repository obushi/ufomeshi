require 'test_helper'

class DishTest < ActiveSupport::TestCase
  test "should save dish v2015" do
    dish = Dish.new(name: "献立", calorie: 120)
    assert dish.save
  end

  test "should save dish v2016" do
    dish = Dish.new(name: "Menu", calorie: nil)
    assert dish.save
  end
end
