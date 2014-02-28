class RestaurantsController < ApplicationController
  before_filter :authenticate_user!, 
              :only => [:new, :edit, :create, :update, :delete]
  def index
   if (params[:city] || params[:state_search]).present? 
     @search  = Restaurant.solr_search do
      def whereat
      [params[:addy], params[:city], params[:state_search], params[:zip]].compact.join(', ')
      end
      def howfar 
        params[:within].to_i * 1.60934
      end
      with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
     end
     @restaurants = @search.results
   else
    @search  = Restaurant.solr_search do
      with(:location).in_radius(29.587359,-95.515556, 100)
     end
     @restaurants = @search.results
    end
  end

  def new
		  @states = []
    	@user = current_user
    	@restaurant = Restaurant.new
      @employee=@restaurant.aware_employees.build
      @employee.restaurant_roles.build
      @restaurant.areas.build
      @restaurant.type_of_cuisines.build
      @role = Role.all
      @type = ['ServSafe Allergens Online Course', 'AllerTrain']
    	State.all.each do |state|
    	 @states << state.abbreviation
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
   
        format.html { redirect_to new_user_restaurant_path(current_user), notice: @restaurant.errors.full_messages }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
     @restaurant =  Restaurant.find(params[:id])
    respond_to do |format|
      if @restaurant.delete
        format.html { redirect_to current_user, notice: 'Successfully Deleted' }
      else
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
      end
    end
    
  end
  def edit
    
    @cuisines = []
    @restaurant = Restaurant.find(params[:id])
    @states = []  
    @type = ['ServSafe Allergens Online Course', 'AllerTrain']
    Cuisine.all.each do |x|
      if @restaurant.cuisines.include?(x) then puts x else @cuisines << x end 
    end
    State.all.each do |state|
      @states << state.abbreviation
    end
  end
  def update   
    @restaurant = Restaurant.find(params[:id])
      
    if @restaurant.update_attributes(restaurant_params)
      edit_nests
      redirect_to edit_user_restaurant_path, notice: 'Thanks' 
    else 
    render json: @restaurant.errors 
    end
  end
  
  def show

    @restaurant = Restaurant.find(params[:id])
    @roles = []
    @employees = @restaurant.aware_employees.length
    @percent = (@employees.to_f/@restaurant.total_employees.to_f) * 100
    binding.pry
    if @restaurant.repos != ''
      @repos_lat = @restaurant.repos.split(',')[0].strip
      @repos_long = @restaurant.repos.split(',')[1].strip
      binding.pry
    end
    @restaurant.aware_employees.each do |emp|
      emp.roles.each do |role|
        if @roles.include?(role.role)
          p 'exst'
        else
          @roles << role.role
        end
      end
    end
    respond_to do |format|
      format.html{  }
      format.json { render json: [@restaurant,@restaurant.cuisines,@roles,@employees] }
      end
  end
	private	
		def restaurant_params
      	params.require(:restaurant).permit(:name,:address,:city,:state, :email, :phone,:repos,
          :hours,:approved,:website,:facebook_url,:twitter_url,:allergy_eats_url,:role_id,:image,
          :zip,:logo,:total_employees,:description,:is_visible,cuisine_ids:[],neighborhood_ids:[],
          aware_employees_attributes:[:name,:id, :verification,:expiration, :cert_type,role_ids:[],restaurant_roles_attributes:[role_id:[]]],
          type_of_cuisines_attributes:[:id,:restaurant_id,cuisine_id:[]],
          areas_attributes:[:id,:restaurant_id,neighborhood_id:[]]
        )
		end
  
    def edit_nests
      #edit cuisine nests
  
        params[:restaurant][:cuisine_ids].each do |cuisine|
          if cuisine == ''
            TypeOfCuisine.where(restaurant_id: @restaurant.id).each do |record|
              record.destroy
              @restaurant.update!(tags: ' ')
            end
          else
            TypeOfCuisine.create(restaurant_id: @restaurant.id, cuisine_id: cuisine )
             @restaurant.update!(tags: @restaurant.tags + ' ' + Cuisine.find(cuisine).name)
          end
        end
      # edit neighborhoods
        params[:restaurant][:neighborhood_ids].each do |hood|
          if hood == ''
            Area.where(restaurant_id: @restaurant.id).each do |record|
              record.destroy
            end
          else
            Area.create(restaurant_id: @restaurant.id, neighborhood_id: hood )
              @restaurant.update!(tags: @restaurant.tags + ' ' + Neighborhood.find(hood).name)
          end
        end
        #edit employee roles
        if params[:restaurant][:aware_employees_attributes] != nil
          params[:restaurant][:aware_employees_attributes].each do |employee|
            this_emp = AwareEmployee.where(name:employee[1][:name], restaurant_id: @restaurant.id).first
            next if this_emp == nil
            if employee[1][:role_ids] != nil
               employee[1][:role_ids].each do |role|  
                 if role == ''
                   RestaurantRole.where(aware_employee_id:this_emp.id).each do |record|
                     record.destroy
                   end
                 else
                  RestaurantRole.create(aware_employee_id:this_emp.id, role_id:role)
                  AwareEmployee.where(name:this_emp.name, restaurant_id: @restaurant.id).each do |x|
                    if x != this_emp then x.destroy end
                  end
                 end
               end
            else
              employee[1][:restaurant_roles_attributes].first[1][:role_id].each do |role|
                if role !='' then RestaurantRole.create(aware_employee_id:this_emp.id, role_id:role) end
              end
              AwareEmployee.where(name:this_emp.name, restaurant_id: @restaurant.id).each do |x|
                    if x != this_emp then x.destroy end
              end
            end
          end
        end 
    end
    def save_nests(this_restaurant)
      # Save Cuisine Nest
      params[:restaurant][:type_of_cuisines_attributes].first[1][:cuisine_id].each do |cuisine|
        if cuisine != '' 
          TypeOfCuisine.create(restaurant_id: this_restaurant.id, cuisine_id: cuisine )
          this_restaurant.update!(tags: this_restaurant.tags + ' ' + Cuisine.find(cuisine).name)
        end
      end
      # End Cuisine
      # Save Neighborhood Nest
        params[:restaurant][:areas_attributes].first[1][:neighborhood_id].each do |hood|
          if hood != '' 
           Area.create(restaurant_id: this_restaurant.id, neighborhood_id: hood )
            this_restaurant.update!(tags: this_restaurant.tags + ' ' + Neighborhood.find(hood).name)
         end
        end
      # End Neighborhood  
      # Save Employee Roles
      #   iterate through aware_employees
         params[:restaurant][:aware_employees_attributes].each do |employee|
          #find saved emplpyee with the correct name AT the current restaurant
           saved_employee = AwareEmployee.where(name: employee[1][:name], restaurant_id: this_restaurant.id).first
        #   #iterate through restaurant roles and save 
           employee[1][:restaurant_roles_attributes].first[1][:role_id].each do |role|
             if role != '' then RestaurantRole.create(aware_employee_id: saved_employee.id, role_id: role ) end
            end 
          end
      end  
    end