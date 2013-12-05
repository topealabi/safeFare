class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
    	t.string :name, null: false
    	t.string :address, null: false
    	t.string :city, null: false
    	t.string :state, null: false
    	t.string :email, null: false
    	t.string :phone
    	t.string :hours 
    	t.string :website
    	t.string :faceboook_url
    	t.string :twitter_url 
    	t.string :allergy_eats_url

		t.integer :zip, null: false
		t.integer :total_employees, null: false
		t.integer :percent_aware
		t.text :description

    	t.boolean :is_visible?, default: true
    	t.boolean :approved?, default: false
    	t.timestamps
    end
  end
end
