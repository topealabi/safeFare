# app/models/admin_ability.rb
 
# All back end users (i.e. Active Admin users) are authorized using this class
class AdminAbility
	include CanCan::Ability
	 
	def initialize(admin_user)
		admin_user ||= AdminUser.new
			can :manage, :all

		if admin_user.role == "Content Editor"
			can :manage, Post
		end

		if admin_user.role == "SafeFare Admin"
			can :manage, Restaurant
			can :manage, Post
		end

		if admin_user.role == "Super Admin"
			can :manage, :all
		end
	 
		# We operate with three role levels:
		# - Editor
		# - Moderator
		# - Manager
		 
		# An editor can do the following:
		
	end
end


