class TypeOfCuisinesController < ApplicationController
	


	def destroy
	 	@cuisine =  TypeOfCuisine.find(params[:id])
	    respond_to do |format|
	      	if @cuisine.delete
	        	format.html { redirect_to :back, notice: 'Successfully Deleted' }
	      	else
	        format.html { redirect_to root_path, notice: 'There was an error on your form' }
	      	end
	    end
	end
end
