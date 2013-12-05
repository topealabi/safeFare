class States < ActiveRecord::Migration
  def change
   create_table :states do |t|
    	t.string :state, null: false
    	t.string :abbreviation, null:false
    end
  end
end
