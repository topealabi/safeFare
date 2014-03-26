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
['Chef', 'Manager', 'Other'].each do |role|
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
	p 'hello'
	if User.where(email: row["user_email"]).exists?
		@user = User.where(email: row["user_email"]).first
		puts "user_exists"
		puts "now adding this users restaurant"
		if @user.restaurants.where(name:row["restaurant_name"]).exists?
			puts "restaurant exists for this user"
		else
			p "i am creating a new restaurant for an existing user #{@user}"
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
				# if contains at sign
				twitter_url: row["twitter_url"],
				allergy_eats_url: row["allergy_eats_url"],
				zip:row["zip"],
				total_employees:row["total_employees"],
				description:row["description"],
				kid_friendly:row["kid_friendly?"],
				)
			if @restaurant.save
				puts 'saved a restaurant for an existing user'
				puts 'what about its cuisines?'
					if Restaurant.where(name:@restaurant.name).length > 1
	      				Restaurant.update(@restaurant.id, url: @restaurant.name.gsub(/[ ']/, '-') + Restaurant.where(name:@restaurant.name).length.to_s)
		   			else
		      			Restaurant.update(@restaurant.id, url: @restaurant.name.gsub(/[ ']/, '-'))

		    		end
				row['cuisine'].split(',').each do |cuisine|
					p "does this cuisine exist?"
					if Cuisine.where(name:cuisine).length > 0
						p "yes, cool, lets associate it to your restaurant"
						@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: Cuisine.where(name:cuisine).first.id)
						if @type.save
							p 'saved existing cuisine to restaurant'
						end
					else
						p "no this cuisine doesnt exist, lets save it"
						@new_cuisine = Cuisine.create(name:cuisine)
						if @new_cuisine.save
							p "cool, now this cuisine exists, lets associate it to this restaurant"
							@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: Cuisine.where(name:cuisine).first.id)
							if @type.save
								p 'saved existing cuisine to restaurant'
								
							else
								p 'error saving type of cuisine'
							end
						else
							p 'error saving new cuisine'
						end
					end	
				end
				p 'all the cuisines are saved, now for the employees'
				@employee = AwareEmployee.create(
						 name: row["employee_name"],
						 verification:'seededbySAFEFARE',
						 cert_type: 'AllerTrain',
						 expiration: DateTime.new(2015,2,3),           
   				         restaurant_id: @restaurant.id
   				         )
					
				if @employee.save
					p 'emp saved, what about his/her roles'
					row['employee_role'].split(',').each do |role|
						p "does this role exist?"
						if Role.where(role:role).length > 0
							p "yes, cool, lets associate it to your employee"
							@type = RestaurantRole.create(aware_employee_id:@employee.id, role_id: Role.where(role:role).first.id)
							if @type.save
								p 'saved existing role to emplotee'
								
							end
						else
							p "no this role doesnt exist, lets save it"
							@new_role = Role.create(role:role)
							if @new_role.save
								p "cool, now this cuisine exists, lets associate it to this restaurant"
								@type = RestaurantRole.create(aware_employee_id:@employee.id, role_id: @new_role.id)
								if @type.save
									p 'saved existing role to emplotee'
								end
							else
								p 'error saving new role'
							end
						end
					end		
				else
				p 'this employee didnt save'
				end
			else
				p 'restraunt did not save'
			end
		end
	else
		p "hello new user"
		@user = User.new(email: row["user_email"], password:"safeFare123", name:row["user_name"])
		@user.skip_confirmation!
			if @user.save
				puts "saved new user now saving #{@user.name} restaurant"
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
					puts "saved #{@user.name} restaurant named #{@restaurant.name}"
					puts 'what about its cuisines?'
						if Restaurant.where(name:@restaurant.name).length > 1
	      				Restaurant.update(@restaurant.id, url: @restaurant.name.gsub(/[ ']/, '-') + Restaurant.where(name:@restaurant.name).length.to_s)
			   			else
			      		Restaurant.update(@restaurant.id, url: @restaurant.name.gsub(/[ ']/, '-'))
			    		end
				
					row['cuisine'].split(',').each do |cuisine|
						p "does this cuisine exist?"
						if Cuisine.where(name:cuisine).length > 0
							p "yes, cool, lets associate it to your restaurant"
							@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: Cuisine.where(name:cuisine).first.id)
							if @type.save
								p 'saved existing cuisine to restaurant'
								
							end
						else
							p "no this cuisine doesnt exist, lets save it"
							@new_cuisine = Cuisine.create(name:cuisine)
							if @new_cuisine.save
								p "cool, now this cuisine exists, lets associate it to this restaurant"
								@type = TypeOfCuisine.create(restaurant_id:@restaurant.id, cuisine_id: @new_cuisine.id)
								if @type.save
									p 'saved existing cuisine to restaurant'
								
								else
									p 'error saving type of cuisine'
								end
							else
								p 'error saving new cuisine'
							end
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
						p 'emp saved, what about his/her roles'
						row['employee_role'].split(',').each do |role|
							p "does this role exist?"
							if Role.where(role:role).length > 0
								p "yes, cool, lets associate it to your employee"
								@type = RestaurantRole.create(aware_employee_id:@employee.id, role_id: Role.where(role:role).first.id)
								if @type.save
									p 'saved existing role to emplotee'
									
								end
							else
								p "no this role doesnt exist, lets save it"
								@new_role = Role.create(role:role)
								if @new_role.save
									p "cool, now this cuisine exists, lets associate it to this restaurant"
									@type = RestaurantRole.create(aware_employee_id:@employee.id, role_id: @new_role.id)
									if @type.save
										p 'saved existing role to emplotee'
									end
								else
									p 'error saving new role'
								end
							end
						end		
					else
						p 'this employee didnt save'
						binding.pry
					end
				else
				p 'problem with restaurant'
				
			end
		end
	end
end

