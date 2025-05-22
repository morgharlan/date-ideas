class CreateDateIdeas < ActiveRecord::Migration[7.1]
   def change
    create_table :date_ideas do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :budget, precision: 8, scale: 2
      t.string :time_of_day
      t.string :setting
      t.string :effort
      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6
      t.string :city
      t.timestamps
    end
  end
end
