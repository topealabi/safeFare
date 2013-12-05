class CreateAwareEmployees < ActiveRecord::Migration
  def change
    create_table :aware_employees do |t|
		t.string :verification, null: false
  		t.string :name, null: false
  		t.boolean :approved?, default: false
  		t.datetime :expiration, null: false
  		t.integer :restaurant_id, null: false	
      	t.timestamps
    end
  end
end
