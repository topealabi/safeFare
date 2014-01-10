ActiveAdmin.register AwareEmployee do
  belongs_to :restaurant
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
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
    column :verification
    column :restaurant
    column :approved?
    
    default_actions
  end
  
end
