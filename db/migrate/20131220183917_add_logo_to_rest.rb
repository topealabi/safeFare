class AddLogoToRest < ActiveRecord::Migration
  def change
  add_column :restaurants, :logo, :string
  end
end
