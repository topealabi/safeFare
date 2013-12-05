require 'spec_helper'

describe AwareEmployee do
  it { should belong_to :restaurant }
  it { should validate_presence_of :name }  
  it { should validate_presence_of :verification }  
  it { should have_many :restaurant_roles }  
end
