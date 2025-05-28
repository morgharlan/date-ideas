class AddDetailedPlanToDateIdeas < ActiveRecord::Migration[7.1]
  def change
    add_column :date_ideas, :detailed_plan, :text
  end
end
