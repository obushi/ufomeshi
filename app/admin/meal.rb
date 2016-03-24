ActiveAdmin.register Meal do

  menu priority: 2

  permit_params :served_on, :meal_type, :calorie, :protein, :fat, :carbohydrae, :salt
  config.filters = false

  index do
    id_column
    column :served_on
    column :meal_type do |m|
      case m.meal_type
      when 'breakfast'; '朝食'
      when 'lunch';     '昼食'
      when 'dinner';    '夕食'
      end
    end
    column :calorie
    column :protein
    column :fat
    column :carbohydrate
    column :salt
    column :dishes do |m|
      link_to '献立を見る', admin_dishes_path + '?q[meal_id_eq]=' + m.id.to_s
    end
    actions
  end
end
