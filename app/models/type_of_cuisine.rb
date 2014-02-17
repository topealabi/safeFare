class TypeOfCuisine < ActiveRecord::Base
	belongs_to :restaurant
	belongs_to :cuisine

	searchable do
    integer :cuisine_id 
    

  end
end
