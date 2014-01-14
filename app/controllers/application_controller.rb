class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  	#redirects admins without permission to admin root path
  	def access_denied(exception)
  		redirect_to root_path, :alert => exception.message	
  	end

  	#Redirect to the user's page after log in.
	def after_sign_in_path_for(resource)
	  if resource.is_a?(AdminUser)
		admin_dashboard_path(resource)
	  end
	end

end
