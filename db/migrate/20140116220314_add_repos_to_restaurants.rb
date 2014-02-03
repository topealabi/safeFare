class AddReposToRestaurants < ActiveRecord::Migration
  def change
	add_column :restaurants, :repos, :string   	
  end
end
