class Restaurant < ActiveRecord::Base
	VALID_STATES = ['CA']
  	
  	State.all.each do |state| 
  		VALID_STATES << state.state
  	end
  	
	validates_presence_of :name, :address, :city, :zip
  validates_inclusion_of :state,
    in: VALID_STATES
  validates_numericality_of :total_employees
 	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :name, uniqueness: true
 	belongs_to :user,
 	  inverse_of: :restaurants
	has_many :cuisines, through: :type_of_cuisines
  has_many :type_of_cuisines,
    dependent: :destroy
  has_many :aware_employees,
   	inverse_of: :restaurant,
    dependent: :destroy 
  has_many :changeorders,
   	inverse_of: :restaurant,
    dependent: :destroy 

  accepts_nested_attributes_for :aware_employees

  accepts_nested_attributes_for :type_of_cuisines

end
