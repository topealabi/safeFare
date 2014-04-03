class AdminMailer < ActionMailer::Base
  default to: Proc.new { AdminUser.pluck(:email) },
          from: 'info@safefare.org'
 
  def admin_create_email(user, restaurant)
  
  	@restaurant = restaurant
    @user = user
    mail(subject: 'A New Restaurant Has Been Added to the SafeFare Database')
  end
  def admin_problem_email(user, restaurant)

  	@restaurant = restaurant
    @user = user
    mail(subject: 'A Restaurant has Deleted all of their Employees')
  end
end
