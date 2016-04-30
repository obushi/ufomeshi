json.meals Api::V1::Meal.name_like(@q) do |meal|
  json.date meal.served_on
  json.type meal.meal_type

  json.dishes meal.dishes.map( &:name )
end
