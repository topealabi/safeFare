class CreateTypeOfCuisines < ActiveRecord::Migration
  def change
    create_table :type_of_cuisines do |t|
      t.integer :restaurant_id, null: false
      t.integer :cuisine_id, null: false
      t.timestamps
    end
  end
end
