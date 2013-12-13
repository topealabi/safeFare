class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index 
  end
  
  def show
    @user = User.find(params[:id])
    @restaurants = @user.restaurants
  end

  def new
  end
end
