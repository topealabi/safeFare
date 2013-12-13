class Changecolumnname < ActiveRecord::Migration
  def up
	rename_column :changeorders, :status?, :approved?
  end
  def down
	rename_column :changeorders, :approved?, :status?
  end
end
