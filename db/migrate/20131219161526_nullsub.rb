class Nullsub < ActiveRecord::Migration
  def up
  	remove_column :restaurant_roles, :role_id
  	add_column :restaurant_roles, :role_id, :integer
  end
  def down
  	remove_column :restaurant_roles, :role_id
  	add_column :restaurant_roles, :role_id, :integer
  end
end
