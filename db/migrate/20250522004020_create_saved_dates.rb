class CreateSavedDates < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_dates do |t|
      t.references :user, null: false, foreign_key: true
      t.references :date_idea, null: false, foreign_key: true
      t.text :note
      t.boolean :favorite, default: false
      t.boolean :completed, default: false
      t.timestamps
    end
    
    add_index :saved_dates, [:user_id, :date_idea_id], unique: true
  end
end
