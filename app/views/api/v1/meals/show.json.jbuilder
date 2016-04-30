json.meals Api::V1::Meal.where(served_on: @date.to_date) do |meal|
  json.date meal.served_on
  json.type meal.meal_type

  json.dishes meal.dishes.map( &:name )
end
