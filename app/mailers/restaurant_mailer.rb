class RestaurantMailer < ActionMailer::Base
  default from: "Admin@SafeFare.org"
  def create_email(user, restaurant)
  	@restaurant = restaurant
    @user = user
    mail(to: @user.email, subject: 'SafeFARE Restaurant Registration Initiated')
  end
  def approve_email(user, restaurant)
  	@restaurant = restaurant
    @user = user
    mail(to: @user.email, subject: 'Congratulations from SAFEFARE')
  end
end
