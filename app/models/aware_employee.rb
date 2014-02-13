class AwareEmployee < ActiveRecord::Base
	belongs_to :restaurant,
		inverse_of: :aware_employees

	has_many :restaurant_roles,
   		inverse_of: :aware_employee
   	has_many :roles, through: :restaurant_roles
   	validates_presence_of :name, :verification
   	
   	accepts_nested_attributes_for :restaurant_roles, :reject_if => lambda { |a| a[:role_id].blank? }, :allow_destroy => true
end
