require 'spec_helper'

describe AwareEmployee do
  it { should belong_to :restaurant }
  it { should validate_presence_of :name }  
  it { should validate_presence_of :verification }  
  it { should have_many :restaurant_roles }

  it 'has has associations through join tables' do
    
    restaurant = FactoryGirl.create(:restaurant)
    employee = FactoryGirl.create(:aware_employee, restaurant_id: restaurant.id)
    role = FactoryGirl.create(:role, role: 'chef')
    join = FactoryGirl.create(:restaurant_role, aware_employee_id: employee.id, role_id: role.id)
  
    expect(employee.roles.first.id).to eql(role.id) 
    expect(restaurant.aware_employees.first.roles.first.role).to eql('chef')
  end

end
