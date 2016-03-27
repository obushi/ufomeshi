class CreateConvertStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :convert_statuses do |t|
      t.string :file_name
      t.datetime :uploaded_at
      t.integer :status
      t.date :start_on
      t.date :end_on

      t.timestamps
    end
  end
end
