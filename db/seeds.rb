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
CSV.foreach("db/rest.csv", headers: true) do |row|
	if User.where(email: row["user_email"]).exists?
		@user = User.where(email: row["user_email"]).first
		puts "user_exists"
		puts "now adding this users restaurant"
	
		if @user.restaurants.where(name:row["restaurant_name"]).exists?
			puts "restaurant exists for this user"
		else
			@restaurant = Restaurant.create(
				user_id: @user.id,
				name:row["restaurant_name"],
				address:row["address"],
				city:row["city"],
				state:row["state"],
				email:row["email"],
				phone:row["phone"],
				hours:row["hours"],
				website:row["website"],
				facebook_url: row["facebook_url"],
				twitter_url: row["twitter_url"],
				allergy_eats_url: row["allergy_eats_url"],
				zip:row["zip"],
				total_employees:row["total_employees"],
				description:row["description"],
				kid_friendly:row["kid_friendly?"],
				)
			if @restaurant.save
				puts 'saved this restaurant'
				puts 'what about its cuisines?'
				if Cuisine.where(name:row["cuisine"]).length > 0
					@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: Cuisine.where(name:row["cuisine"]).first.id)
					if @type.save
						p 'saved cuisine to restaurant'
					end
				end

				@employee = AwareEmployee.create(
						 name: row["employee_name"],
						 verification:'seededbySAFEFARE',
						 cert_type: 'AllerTrain',
						 expiration: row["expiration"],           
   				         restaurant_id: @restaurant.id
   				         )
					
					if @employee.save
						p 'emp saved'
					end
			else
			end
		end
	else
		@user = User.new(email: row["user_email"], password:"safeFare123")
		@user.skip_confirmation!
			if @user.save
				puts "saved new user now saving restaurant"
				
				@restaurant = Restaurant.create(
					user_id: @user.id,
					name:row["restaurant_name"],
					address:row["address"],
					city:row["city"],
					state:row["state"],
					email:row["email"],
					phone:row["phone"],
					hours:row["hours"],
					website:row["website"],
					facebook_url: row["facebook_url"],
					twitter_url: row["twitter_url"],
					allergy_eats_url: row["allergy_eats_url"],
					zip:row["zip"],
					total_employees:row["total_employees"],
					description:row["description"],
					kid_friendly:row["kid_friendly?"],
					)
				if @restaurant.save
					puts 'saved this restaurant'
					puts 'what about its cuisines?'
					if Cuisine.where(name:row["cuisine"]).length > 0
						@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: Cuisine.where(name:row["cuisine"]).first.id)
						if @type.save
							p 'saved cuisine to restaurant'
						end
					end
				
					@employee = AwareEmployee.create(
						 name: row["employee_name"],
						 verification:'seededbySAFEFARE',
						 cert_type: 'AllerTrain',
						 expiration: DateTime.new(2015,2,3),           
   				         restaurant_id: @restaurant.id
   				         )
					
					if @employee.save
						p 'emp saved'
					end
				else
					p 'this didnt save'
				end
			else
				'problem with user'	
			end
	end

end

