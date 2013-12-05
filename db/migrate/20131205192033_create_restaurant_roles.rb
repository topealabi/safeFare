class CreateRestaurantRoles < ActiveRecord::Migration
  def change
    create_table :restaurant_roles do |t|
      t.string :role, null: false
      t.integer :aware_employee_id, null: false		
      t.timestamps
    end
  end
end
