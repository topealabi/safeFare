ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
   
    
    columns do
      column do
        panel "Info" do
          para "Welcome to SafeFARE's Admin Panel."
          para "To Approve Restaurants, visit their edit page and find and check the approve checkbox"
          strong "Here you can create, edit, view and approve:"
          ul do
            li strong { link_to "Admins", admin_admin_users_path }
            li strong { link_to "Restaurants", admin_restaurants_path }
            li strong { link_to "Cuisines", admin_cuisines_path }
            li strong { link_to "Neighborhoods", admin_neighborhoods_path }
            li strong { link_to "Employees", admin_aware_employees_path }
            li strong { link_to "Employee Roles", admin_roles_path }
          end
          para "For any questions please reach out to Dhruv.Mehrotra@TheMechanism.com"

        end
      end
      column do
        panel "Recent Restaurants" do
          ul do
            Restaurant.all(:order => 'created_at DESC', :limit => 10).map do |post|
              li link_to(post.name, admin_restaurant_path(post))
            end
          end
          para "Click Each Restaurant to See More Info"
          strong { link_to "View All Restaurants", admin_restaurants_path }
        end
      end
      column do
        panel "Pending Restaurants" do
          ul do
            Restaurant.where(approved:false).map do |post|
              li link_to(post.name, edit_admin_restaurant_path(post))
            end
          end
           para "Click Each Restaurant to See More Info"
           strong { link_to "View All Restaurants", admin_restaurants_path }
        end
      end

      
    end
  end # content
end
