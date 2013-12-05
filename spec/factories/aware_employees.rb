# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :aware_employee do
  	name 'Dhruv'
  	verification 'ddddxxxx'
  	expiration DateTime.new(2001,2,3)
  	
  end
end
