require 'spec_helper'

describe Restaurant do
  it { should validate_presence_of :name }  
  it { should validate_presence_of :address }
  it { should validate_presence_of :city }
  it { should have_valid(:email).when('drm336@nyu.edu') }
  it { should_not have_valid(:email).when('dsgufgdsuifgeg',12325,'', " ") }

  it { should validate_presence_of :zip }
  # it { should have_valid(:state).when('CA') }
  it { should_not have_valid(:state).when('Thisisnotastate') }
  it { should validate_numericality_of :total_employees }
  it { should belong_to :user } 
  it { should have_many :type_of_cuisines } 
  it { should have_many :aware_employees }
  it { should have_many :changeorders }

  it 'has aware employees' do
    
    restaurant = FactoryGirl.create(:restaurant)
    employee = FactoryGirl.create(:aware_employee, restaurant_id: restaurant.id)
    expect(restaurant.aware_employees.first.id).to eql(employee.id) 

  end
  it 'has cuisines through type_of_cuisine' do
    
    restaurant = FactoryGirl.create(:restaurant)
    cuisine = FactoryGirl.create(:cuisine)
    join = FactoryGirl.create(
      :type_of_cuisine, 
      restaurant_id: restaurant.id, 
      cuisine_id: cuisine.id)
   
    expect(restaurant.cuisines.first.id).to eql(cuisine.id) 

  end

 
end
