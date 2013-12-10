require 'spec_helper'

describe RestaurantRole do
	it { should belong_to :aware_employee }
	it { should belong_to :role }  
end
