# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)require 'csv'
require 'csv'
CSV.foreach('db/states.csv', headers: true) do |row|
	state = State.where({state: row[0]})
	if state.length >= 1
		puts 'exists'
	else
		State.create(state: row[0], abbreviation: row[1])
		puts row
		VALID_STATES = ['CA']

	  	State.all.each do |state| 
	  		VALID_STATES << state.abbreviation
	  	end
	end
end


CSV.foreach('db/cuisines.csv', headers: false) do |cuisine|
	cuisine_exist = Cuisine.where({name: cuisine[0]})
	if cuisine_exist.length >= 1
		puts 'exist'
	else
		Cuisine.create(name: cuisine[0])
		puts cuisine[0]
	end
end
['Chef', 'Server', 'Front of House', 'Back of House'].each do |role|
	role_exist = Role.where({role: role})
	
	if role_exist.length >= 1
		puts 'exist'
	else
		Role.create(role: role)
		puts role
	end
end
['Bushwick', 'Allston', 'Bed Stuy', 'East Village'].each do |hood|
	hood_exist = Neighborhood.where({name: hood})
	
	if hood_exist.length >= 1
		puts 'This hood exists yo'
	else
		Neighborhood.create(name: hood)
		puts hood
	end
end