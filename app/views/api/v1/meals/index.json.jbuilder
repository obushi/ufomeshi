json.meals Api::V1::Meal.from_now do |meal|
  json.date meal.served_on
  json.type meal.meal_type

  json.dishes meal.dishes.map( &:name )
end
