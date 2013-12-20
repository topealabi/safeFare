class RestaurantsController < ApplicationController
	def new
		  @states = []
    	@user = current_user
    	@restaurant = Restaurant.new
    	@employee = @restaurant.aware_employees.build
      @employee.restaurant_roles.build
      @restaurant.type_of_cuisines.build
      @role = Role.all
    	State.all.each do |state|
    	@states << state.state
    	end
  end
	def create
	 @restaurant = Restaurant.new(restaurant_params)
   @restaurant.user_id = current_user.id
    respond_to do |format|
      if @restaurant.save
        save_nests(@restaurant)
        format.html { redirect_to current_user, notice: 'Restaurant was successfully created.' }
        format.json { render action: 'show', status: :created, location: @restaurant }
      else
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end
  def edit
       @restaurant = Restaurant.find(params[:id])

  end
  def update
  binding.pry
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update_attributes(restaurant_params)
         render json: @restaurant
      else
         render json: @restaurant.errors
      end
    end
  def show
      @restaurant = Restaurant.find(params[:id])
  end
	private	
		def restaurant_params
      	params.require(:restaurant).permit(
  				:name, :address, :city, 
  				:state, :email, :phone,
  				:hours, :website, :facebook_url,
  				:twitter_url, :allergy_eats_url, :zip, :logo,
  				:total_employees, :description, :is_visible?,
  				aware_employees_attributes:[:verification, :name, :expiration, restaurant_roles_attributes:[role_id:[]]],
          type_of_cuisines_attributes:[cuisine_id:[]],
        )
		end
    def save_nests(this_restaurant)
      params[:restaurant][:type_of_cuisines_attributes].first[1][:cuisine_id].each do |cuisine|
        if cuisine != ''
          TypeOfCuisine.create(restaurant_id: this_restaurant.id, cuisine_id: cuisine )
        end
      end
      params[:restaurant][:aware_employees_attributes].first[1][:restaurant_roles_attributes].first[1][:role_id].each do |role|
        if role != ''
          this_restaurant.aware_employees.each do |employee|
            RestaurantRole.create(aware_employee_id: employee.id, role_id: role )
          end
        end
      end
    end    
  end