class TypeOfCuisinesController < ApplicationController

def index
    @type_of_cuisine = TypeOfCuisine.all
end

def destroy

  @type_of_cuisine =  TypeOfCuisine.find(params[:id])
    respond_to do |format|
      if @type_of_cuisine.delete
       
        format.html { redirect_to :back, notice: 'Successfully Deleted' }
       
      else
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
        
      end
    end
  end
end
