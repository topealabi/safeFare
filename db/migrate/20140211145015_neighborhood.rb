class Neighborhood < ActiveRecord::Migration
  def change
  	create_table :neighborhoods do |t|
    	t.string :name, null: false
    	t.timestamps
    end
    create_table :areas do |t|
    	t.integer :restaurant_id, null: false
    	t.integer :neighborhood_id
    	t.timestamps
    end
  end
end
