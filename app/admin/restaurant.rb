ActiveAdmin.register Restaurant do
  

  index do
    column :name
    column :address
    bool_column :is_visible
    bool_column :approved
    actions
  end
  show do
    attributes_table do
      row :name
      row :email
      bool_row :approved
      bool_row :is_visible
    end
  end  
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
   #permit_params :list, :of, :attributes, :on, :model
   permit_params :name, :address, :city, :state, :email, :phone, :hours,
                  :website, :facebook_url, :twitter_url, :allergy_eats_url,
                  :zip, :total_employees, :percent_aware, :description, :is_visible, :approved, :created_at, 
                  :updated_at, :user_id, :logo
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
end
  

