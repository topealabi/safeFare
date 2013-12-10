class RestaurantRole < ActiveRecord::Base
	belongs_to :aware_employee,
		inverse_of: :restaurant_roles
	belongs_to :role

end
