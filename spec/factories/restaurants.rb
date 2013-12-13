# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :restaurant do
  	name 'restaurant'
  	address '1234 mott street'
  	city 'NewYork'
  	state 'CA'
  	email 'rest@example.com'
  	zip 12345688
  	total_employees 12
  	user_id 1
  end
end
