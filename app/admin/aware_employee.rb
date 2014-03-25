ActiveAdmin.register AwareEmployee do
    # belongs_to :restaurant
    # navigation_menu :restaurant

  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  filter :restaurant
  filter :name
  filter :approved?
  filter :expiration
  filter :approved
  filter :created_at
  permit_params :name, :verification, :cert_type, :expiration, :approved?, :role_id, restaurant_roles_attributes:[:role_id, :_destroy]
  controller do
    def update
      @employee = AwareEmployee.find(params[:id])
       if @employee.update_attributes(name: params[:aware_employee][:name], verification: params[:aware_employee][:verification],
        cert_type: params[:aware_employee][:cert_type], approved?: params[:aware_employee][:approved?])
          redirect_to admin_aware_employees_path, notice: 'Thanks' 
          admin_edit_nests(@employee)
        else
       
          redirect_to :back
        end
    end
    def admin_edit_nests(employee)
      RestaurantRole.where(aware_employee_id: employee.id).each do |x|
        x.destroy
      end
      params[:aware_employee][:restaurant_roles_attributes].each do |role|
        if role[1][:_destroy] != '1'
          if employee.roles.where(id:role[1][:role_id]).length == 0 && role[1][:role_id] != ''
            RestaurantRole.create(role_id: role[1][:role_id], aware_employee_id: employee.id)
          end
        else
          RestaurantRole.where(aware_employee_id: employee.id, role_id: role[1][:role_id]).each do |x|
            x.delete
          end
        end
      end
    end          
  end

index do
    column :name
    column :restaurant
    column :approved?
    default_actions
  end
  show do
    attributes_table do
      row :name
      bool_row :approved
     
    end
  end 

form do |f|
      f.inputs "Details" do
      f.input :name
      f.input :verification
      f.input :approved?
      f.input :cert_type, :as => :select, :collection => ['ServSafe Allergens Online Course', 'AllerTrain'], :include_blank => false, :selected => (aware_employee.cert_type if !aware_employee.cert_type.nil?)
      f.input :expiration
      end
      f.inputs "Employee Roles" do
       f.has_many :restaurant_roles, :allow_destroy => true, :new_record => true do |cf|
           cf.input :role, :as=> :select, :member_label=>:role
        end
      end
      f.actions
    end

  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
  
end
