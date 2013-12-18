class RestaurantsController < ApplicationController
	def new
		  @states = []
    	@user = current_user
    	@restaurant = Restaurant.new
    	@restaurant.aware_employees.build
      @restaurant.type_of_cuisines.build

    	State.all.each do |state|
    	@states << state.state
    	end
  end
	def create

	 @restaurant = Restaurant.new(restaurant_params)
   @restaurant.user_id = current_user.id
   
    respond_to do |format|
      if @restaurant.save
        save_cuisine(@restaurant)
        format.html { redirect_to current_user, notice: 'Restaurant was successfully created.' }
        format.json { render action: 'show', status: :created, location: @restaurant }
      else
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

	private	
		def restaurant_params
  		
      	params.require(:restaurant).permit(
  				:name, :address, :city, 
  				:state, :email, :phone,
  				:hours, :website, :facebook_url,
  				:twitter_url, :allergy_eats_url, :zip,
  				:total_employees, :description, :is_visible?,
  				aware_employees_attributes:[:verification, :name, :expiration],
          type_of_cuisines_attributes:[cuisine_id:[]]
        )
		end
    def save_cuisine(this_restaurant)
      params[:restaurant][:type_of_cuisines_attributes].first[1][:cuisine_id].each do |x|
        if x != ''
          TypeOfCuisine.create(restaurant_id: this_restaurant.id, cuisine_id: x )
        end
      end
    end
  end