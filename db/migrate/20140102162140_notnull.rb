class Notnull < ActiveRecord::Migration
  def change
  	remove_column :type_of_cuisines, :cuisine_id
  	add_column :type_of_cuisines, :cuisine_id, :integer
  end
end
