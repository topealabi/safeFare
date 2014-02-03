class RestaurantsController < ApplicationController
  before_filter :authenticate_user!, 
              :only => [:new, :edit, :create, :update, :delete]
  def index
    @search  = Restaurant.solr_search do
      fulltext params[:search]
    end
    @restaurants = @search.results
  end
  def new
		  @states = []
    	@user = current_user
    	@restaurant = Restaurant.new
    	@employee = @restaurant.aware_employees.build
      @employee.restaurant_roles.build
      @restaurant.type_of_cuisines.build
      @role = Role.all
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
        binding.pry
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end
  def edit
    @cuisines = []
    @restaurant = Restaurant.find(params[:id])
    @type_of_cuisines = TypeOfCuisine.new
    @states = []  
    Cuisine.all.each do |x|
      if @restaurant.cuisines.include?(x) then puts x else @cuisines << x end 
    end
    State.all.each do |state|
      @states << state.abbreviation
    end
  end
  def update   
    @restaurant = Restaurant.find(params[:id])
    new_employees = [ 
      params[:restaurant][:employee_1],
      params[:restaurant][:employee_2],
      params[:restaurant][:employee_3]
    ]
    if params[:restaurant][:aware_employees_attributes] != nil
      params[:restaurant][:aware_employees_attributes].each do |employee|
        update_employees_roles(employee)
      end
    end
    params[:restaurant][:cuisine_ids].each do |cuisine|
      if cuisine == ''
        TypeOfCuisine.where(restaurant_id: @restaurant.id).each do |record|
          record.destroy
        end
      else
        TypeOfCuisine.create(restaurant_id: @restaurant.id, cuisine_id: cuisine )
      end
    end
    add_employees(new_employees)
    if @restaurant.update_attributes(restaurant_params) then redirect_to edit_user_restaurant_path, notice: 'Sweet Edit Bro' else render json: @restaurant.errors end
  end
  
  def show
    @restaurant = Restaurant.find(params[:id])
  end
	private	
		def restaurant_params
      	params.require(:restaurant).permit(
  				:name, :address, :city, 
  				:state, :email, :phone,
          :repos, :aware_employee,
  				:hours, :approved, :website, :facebook_url,
  				:twitter_url, :allergy_eats_url, :zip, :logo,
  				:total_employees, :description, :is_visible, employees_attributes:[:verification, :id,:name, :expiration, restaurant_roles_attributes:[:id,:restaurant_id,role_id:[]]],
  				aware_employees_attributes:[:verification, :id,:name, :expiration, restaurant_roles_attributes:[:id,:restaurant_id,role_id:[]]], restaurant_roles_attributes:[:id,:restaurant_id,:employee_id,role_id:[] ],
          type_of_cuisines_attributes:[:id,:restaurant_id,cuisine_id:[]]
        )
		end
    def update_employees_roles(employee)
      employee[1][:role_ids].each do |role|
        if role == ''
          RestaurantRole.where(aware_employee_id: employee[1][:id]).each do |record|
            record.destroy
          end
        else
          RestaurantRole.create(aware_employee_id: employee[1][:id], role_id: role )
        end
      end
    end
    def add_employees(new_employees)
      new_employees.each do |employee|
        if employee[:name] != ''
          current_employee = AwareEmployee.new(
            name: employee[:name],
            restaurant_id: params[:id],
            verification: employee[:verification],
            expiration: [employee["expiration(1i)"],  employee["expiration(2i)"],  employee["expiration(3i)"]].reject(&:empty?).join('-') )         
          if current_employee.save
            if employee[:restaurant_roles][:role_id].length > 1
                employee[:restaurant_roles][:role_id].each do |role|
                  if role !='' then RestaurantRole.create(aware_employee_id: current_employee.id, role_id: role ) end
                end
            end
          end
        end
      end
    end
    def save_nests(this_restaurant)
      params[:restaurant][:type_of_cuisines_attributes].first[1][:cuisine_id].each do |cuisine|
        if cuisine != ''
          TypeOfCuisine.create(restaurant_id: this_restaurant.id, cuisine_id: cuisine )
        end
      end
      new_employee = AwareEmployee.new(
            name: params[:restaurant][:aware_employee][:name],
            restaurant_id: this_restaurant.id,
            verification: params[:restaurant][:aware_employee][:verification],
            expiration: [ params[:restaurant][:aware_employee]["expiration(1i)"],  
                          params[:restaurant][:aware_employee]["expiration(2i)"],  
                          params[:restaurant][:aware_employee]["expiration(3i)"]].reject(&:empty?).join('-') 
            )
     
      if new_employee.save
        params[:restaurant][:aware_employee][:restaurant_roles][:role_id].each do |role|
          if role != '' then RestaurantRole.create(aware_employee_id: new_employee.id, role_id: role ) end
        end
      end
    end  
  end