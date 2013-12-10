require 'spec_helper'

describe Role do
     it { should validate_presence_of :role }
     it { should have_many :restaurant_roles }
end
