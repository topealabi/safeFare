ActiveAdmin.register Restaurant do

  
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
  
  index do
    column :name
    column :email
    column :is_visible
    column :approved
    
    default_actions
  end

end
  

