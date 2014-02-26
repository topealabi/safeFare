class AddTags < ActiveRecord::Migration
  def change
  	add_column :restaurants, :tags, :string, :default => ""
  end
end
