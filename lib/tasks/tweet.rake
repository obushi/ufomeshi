namespace :tweet do
  desc "献立をツイートする"
  task breakfast: :environment do
    p dishes = Meal.today.where(meal_type: "breakfast").first.dishes
  end
end
