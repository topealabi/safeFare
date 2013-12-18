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
	end
end

['Chinese', 'Thai', 'Mexican', 'American'].each do |cuisine|
	cuisine_exist = Cuisine.where({name: cuisine})
	
	if cuisine_exist.length >= 1
		puts 'exist'
	else
		Cuisine.create(name: cuisine)
		puts cuisine
	end
end