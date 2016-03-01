class AddMealIdToDishes < ActiveRecord::Migration[5.0]
  def change
    add_reference :dishes, :meal, foreign_key: true
  end
end
