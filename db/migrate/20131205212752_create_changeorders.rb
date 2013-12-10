class CreateChangeorders < ActiveRecord::Migration
  def change
    create_table :changeorders do |t|
    	t.integer :user_id, null: false
    	t.integer :restaurant_id, null: false
    	t.string :type, null: false
    	t.boolean :status?, default: false
    	
      	t.timestamps
    end
  end
end
