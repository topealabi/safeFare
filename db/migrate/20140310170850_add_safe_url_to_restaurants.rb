class AddSafeUrlToRestaurants < ActiveRecord::Migration
	def up
  	add_column :restaurants, :url, :string
  end
  def down
  	remove_column :restaurants, :url
  end
end
