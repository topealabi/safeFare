require 'spec_helper'

describe RestaurantRole do
	it { should belong_to :aware_employee }
	it { should validate_presence_of :role }  
end
