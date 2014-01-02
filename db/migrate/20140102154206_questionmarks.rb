class Questionmarks < ActiveRecord::Migration
  def change
  	rename_column :restaurants, :approved?, :approved
  	rename_column :restaurants, :is_visible?, :is_visible
  end
end
