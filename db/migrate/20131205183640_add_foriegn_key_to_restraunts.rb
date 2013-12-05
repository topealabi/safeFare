class AddForiegnKeyToRestraunts < ActiveRecord::Migration
  def change
  	add_column :restaurants, :user_id, :integer, null: false
  end
end
