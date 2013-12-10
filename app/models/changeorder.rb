class Changeorder < ActiveRecord::Base
	VALID_TYPES = ['description'] #add more approvable types
	belongs_to :user,
		inverse_of: :changeorders
	belongs_to :restaurant,
		inverse_of: :changeorders
	validates_inclusion_of :type,
    	in: VALID_TYPES	
end
