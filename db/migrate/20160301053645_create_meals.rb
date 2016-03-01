class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.date :served_on
      t.integer :meal_type
      t.integer :calorie
      t.integer :protein
      t.integer :fat
      t.integer :carbohydrate
      t.float :salt

      t.timestamps
    end
  end
end
