class Role < ActiveRecord::Base
  has_many :restaurant_roles
  has_many :aware_employees, through: :restaurant_roles
  validates_presence_of :role



  # searchable do
  # 	text :role
  # 	string :work_place, :multiple => true do
  # 		aware_employees.map do |employee| 
  # 			employee.restaurant.name 
  # 		end 
  # 	end
  # end
end
