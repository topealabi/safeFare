ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  ROLES = %w(editor moderator manager)

  def role?(base_role)
    return false unless role
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  index do
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
