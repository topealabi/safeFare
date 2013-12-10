class Role < ActiveRecord::Base
  has_many :restaurant_roles
  has_many :aware_employees, through: :restaurant_roles
  validates_presence_of :role
end
