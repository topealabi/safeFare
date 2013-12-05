class Restaurant < ActiveRecord::Base
	VALID_STATES = ['CA']
  	
  	State.all.each do |state| 
  		VALID_STATES << state.abbreviation
  	end
  	
	validates_presence_of :name, :address, :city, :zip
  	validates_inclusion_of :state,
    	in: VALID_STATES
  validates_numericality_of :total_employees
 	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

 	belongs_to :user,
 		inverse_of: :restaurants
	has_many :cuisines,
   		inverse_of: :restaurant
   	has_many :aware_employees,
   		inverse_of: :restaurant
   	has_many :change_orders,
   		inverse_of: :restaurant

end
