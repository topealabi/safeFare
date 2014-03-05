class AddIndexToRestaurants < ActiveRecord::Migration
  def up
  	add_index :restaurants, [:latitude, :longitude]
  end

  def down
  	remove_index :restaurants, [:latitude, :longitude]
  end
end
