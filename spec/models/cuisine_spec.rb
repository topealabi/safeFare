require 'spec_helper'

describe Cuisine do
   it { should have_many :type_of_cuisines}
   it { should validate_presence_of :name } 
end
