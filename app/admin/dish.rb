ActiveAdmin.register Dish do

  menu priority: 3

  permit_params :name, :calorie

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

  filter :name
  filter :calorie
  filter :meal_id
end
