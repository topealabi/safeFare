class AwareEmployeesController < ApplicationController
  def update
		@restaurant = Restaurant.find(params[:restaurant_id])
		@employee = @restaurant.aware_employees.find(params[:id])
		respond_to do |format|
      		if @employee.update(employee_params)
        		
        		format.json {render json: @employee }
     		else
        		format.html { render action: 'edit' }
        		format.json { render json: @employee.errors, status: :unprocessable_entity }
      		end
    	end
	end
  def destroy
  @employee =  AwareEmployee.find(params[:id])
    @restaurant = Restaurant.find(params[:restaurant_id])
    @user = current_user
    respond_to do |format|
      if @employee.delete
        if @restaurant.aware_employees.length == 0
          Restaurant.update(@restaurant.id, approved: false)
            AdminMailer.admin_problem_email(@user, @restaurant).deliver
        end
        format.html { redirect_to :back, notice: 'Successfully Deleted' }
      else
        format.html { redirect_to root_path, notice: 'There was an error on your form' }
      end
    end
  end
	private
	def employee_params
      	params.require(:aware_employee).permit(
  				:name, :verification, :expiration, restaurant_roles_ids:[]
        )
	end
end
