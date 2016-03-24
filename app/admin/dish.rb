ActiveAdmin.register Dish do

  menu priority: 3

  permit_params :name, :calorie
  config.filters = false

  index do
    id_column
    column :name
    column :calorie
    column :meal
    actions
  end

  form do |f|
    inputs do
      input :name
      input :calorie
      input :meal_id
    end
    actions
  end
end
