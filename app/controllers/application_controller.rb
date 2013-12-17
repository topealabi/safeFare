class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def after_sign_in_path_for(resource)
	 #Redirect to the user's page after log in.
	  if resource.is_a?(AdminUser)
		admin_dashboard_path(resource)
	  end
	end

end
