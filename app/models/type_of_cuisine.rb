class TypeOfCuisine < ActiveRecord::Base
	belongs_to :restaurant
	belongs_to :cuisine
end
