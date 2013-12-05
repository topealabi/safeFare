class RestaurantRole < ActiveRecord::Base
	belongs_to :aware_employee,
		inverse_of: :restaurant_roles

	validates_presence_of :role
end
