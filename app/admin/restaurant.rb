ActiveAdmin.register Restaurant do
  menu :priority => 1
  config.filters = true
  filter :name
  filter :neighborhood
  filter :city
  filter :state
  filter :zip
  filter :approved
  filter :created_at
  index do
    column :name
    column :approved
    default_actions
  end
  show do
    attributes_table do
      row :name
      row :email
      bool_row :approved
      bool_row :is_visible
    end
  end  
  sidebar "Restaurant Employees", only: [:show, :edit] do
    ul do 
      Restaurant.find(params[:id]).aware_employees.each do |emp|
      li link_to(emp.name, edit_admin_aware_employee_path(emp)) 
      end
    end
  end


# start controller
  controller do
    def new
      @restaurant = Restaurant.new
      @states = []
      State.all.each do |state|
        @states << state.abbreviation
      end
    end
    def create
      @restaurant = Restaurant.new
      params[:restaurant].each do |param|
        if param[0] == "areas_attributes" || param[0] == "type_of_cuisines_attributes"
         
        else
           @restaurant[param[0]] = param[1]
        end
      end
      if @restaurant.save
        create_nests(@restaurant)
        redirect_to admin_restaurant_path(@restaurant), notice: 'Thanks' 
      else
        redirect_to :back
        
      end
    end
    def edit
       @restaurant = Restaurant.find(params[:id])
    end
    def update
      @restaurant = Restaurant.find(params[:id])
      pre_update = @restaurant.approved
       if @restaurant.update_attributes(
        name: params[:restaurant][:name],
        user_id: params[:restaurant][:user_id],
        address:params[:restaurant][:address],
        approved:params[:restaurant][:approved],
        city:params[:restaurant][:city],
        logo:params[:restaurant][:logo],
        state:params[:restaurant][:state],
        email:params[:restaurant][:email],
        phone:params[:restaurant][:phone],
        hours:params[:restaurant][:hours],
        website:params[:restaurant][:website],
        facebook_url:params[:restaurant][:facebook_url],
        twitter_url:params[:restaurant][:twitter_url],
        allergy_eats_url:params[:restaurant][:allergy_eats_url],
        description:params[:restaurant][:description],
        zip:params[:restaurant][:zip],
        total_employees:params[:restaurant][:total_employees],
        percent_aware:params[:restaurant][:percent_aware]
        )
        post_update = @restaurant.approved
        @user = User.find(params[:restaurant][:user_id])

        if pre_update != post_update && post_update != false
          RestaurantMailer.approve_email(@user, @restaurant).deliver
          puts 'sent'
      
        end
        redirect_to admin_restaurants_path(params[:restaurant_id]), notice: 'Thanks' 
          admin_edit_restaurant_nests(@restaurant)
        else
          redirect_to :back
        end
    end
    def create_nests(restaurant)
      if params[:restaurant][:areas_attributes] != nil
        params[:restaurant][:areas_attributes].each do |area|
            if area[1][:neighborhood_id] != '' && @restaurant.neighborhoods.where(id: area[1][:neighborhood_id]).length < 1 
              Area.create(restaurant_id: @restaurant.id, neighborhood_id: area[1][:neighborhood_id])
            end
        end
      end
      if params[:restaurant][:type_of_cuisines_attributes] != nil
         params[:restaurant][:type_of_cuisines_attributes].each do |cuisine|
            if cuisine[1][:cuisine_id] != '' && @restaurant.cuisines.where(id: cuisine[1][:cuisine_id]).length < 1 
              TypeOfCuisine.create(restaurant_id: @restaurant.id, cuisine_id: cuisine[1][:cuisine_id])
            end
        end
      end
    end
    def admin_edit_restaurant_nests(restaurant)
      TypeOfCuisine.where(restaurant_id: restaurant.id).each do |x|
        x.destroy
      end
      Area.where(restaurant_id: restaurant.id).each do |x|
        x.destroy
      end
      if params[:restaurant][:areas_attributes] != nil
        params[:restaurant][:areas_attributes].each do |neighborhood|
          if neighborhood[1][:_destroy] != '1'
            if restaurant.neighborhoods.where(id:neighborhood[1][:neighborhood_id]).length == 0 && neighborhood[1][:neighborhood_id] != ''
              Area.create(neighborhood_id: neighborhood[1][:neighborhood_id], restaurant_id: restaurant.id)
            end
          else
            Area.where(restaurant_id: restaurant.id, neighborhood_id: neighborhood[1][:neighborhood_id]).each do |x|
              x.delete
            end
          end
        end
      end
      if params[:restaurant][:type_of_cuisines_attributes] != nil
        params[:restaurant][:type_of_cuisines_attributes].each do |cuisine|
          if cuisine[1][:_destroy] != '1'
            if restaurant.cuisines.where(id:cuisine[1][:cuisine_id]).length == 0 && cuisine[1][:cuisine_id] != ''
              TypeOfCuisine.create(cuisine_id: cuisine[1][:cuisine_id], restaurant_id: restaurant.id)
            end
          else
            TypeOfCuisine.where(restaurant_id: restaurant.id, cuisine_id: cuisine[1][:cuisine_id]).each do |x|
              x.delete
            end
          end
        end
      end
    end      
  end

# end controller




   form do |f|
      @states = []
      State.all.each do |state|
        @states << state.abbreviation
      end
      f.inputs "Details" do
      f.input :user, :as => :select, :collection => User.all, :member_label => :email, :include_blank => false
      f.input :name
      f.input :address
      f.input :city
      f.input :approved
      f.input :state, :as => :select, :collection => @states, :include_blank => false
      f.input :email
      f.input :phone, placeholder: '(xxx-xxx-xxxx)' 
      f.input :hours, hint: '(e.g., Mon-Fri: 11:30am–11pm; Sat-Sun: 12pm-10pm)'
      f.input :website
      f.input :facebook_url
      f.input :twitter_url
      f.input :allergy_eats_url
      f.input :zip
      f.input :total_employees
      f.input :description, label: "Food Allergy Policies"
      
      f.has_many :areas, :allow_destroy => true, :heading => "Neighborhoods", :new_record => true do |cf|
           cf.input :neighborhood, :as=> :select, :member_label=>:name
      end
      f.has_many :type_of_cuisines, :allow_destroy => true,:heading => "Cuisines", :new_record => true do |cf|
         cf.input :cuisine, :as=> :select, :member_label=>:name
      end
   
      end
     
      
      f.actions
    end
  permit_params :name, :address, :city, :state, :email, :phone, :hours, :user_id,
                  :website, :facebook_url, :twitter_url, :allergy_eats_url,
                  :zip, :total_employees, :percent_aware, :description, :is_visible, :approved, :created_at, 
                  :updated_at, :user_id,:areas_attributes, :type_of_cuisines_attributes
 
end
  

