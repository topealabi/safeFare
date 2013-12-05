class AwareEmployee < ActiveRecord::Base
	belongs_to :restaurant,
		inverse_of: :aware_employees

	has_many :restaurant_roles,
   		inverse_of: :aware_employee

   	validates_presence_of :name, :verification
end
