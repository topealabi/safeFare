ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  #ROLES = %w(editor moderator manager)

  #def role?(base_role)
  #  return false unless role
  #  ROLES.index(base_role.to_s) <= ROLES.index(role)
  #end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    column :role
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      #f.collection_select :role, AdminUser::ROLES, :to_s, :humanize
      f.input :role, :as => :select, :collection => [ "Super Admin", "SafeFare Admin", "Content Editor" ]
    end
    f.actions
  end

  controller do
    def update_resource object, attributes
      attributes.each do |attr|
        if attr[:password].blank? and attr[:password_confirmation].blank?
          attr.delete :password
          attr.delete :password_confirmation
        end
      end

      object.send :update_attributes, *attributes
    end
  end


end
