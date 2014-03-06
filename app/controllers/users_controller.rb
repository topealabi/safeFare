class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index 
  end
  
  def show
    @user = User.find(params[:id])
    @restaurants = @user.restaurants
  end

def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to @user, notice: "Successfully Updated "
    else
      redirect_to @user, notice: @user.errors.full_messages 
    end
  end

  def new
  end
   private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:user).permit(:password, :password_confirmation)
  end
end
