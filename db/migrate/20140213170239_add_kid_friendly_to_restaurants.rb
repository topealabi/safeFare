class AddKidFriendlyToRestaurants < ActiveRecord::Migration
  def up
  	add_column :restaurants, :kid_friendly, :boolean
  end
end
