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
  it { should have_many :cuisines } 
  it { should have_many :aware_employees }
  it { should have_many :change_orders }

  it 'has aware employees' do
    
    restaurant = FactoryGirl.create(:restaurant)
    employee = FactoryGirl.create(:aware_employee, restaurant_id: restaurant.id)
    expect(restaurant.aware_employees.first.id).to eql(employee.id) 

  end

 
end
