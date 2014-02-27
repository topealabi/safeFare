class HomeController < ApplicationController
	def index
	end
	def about
	end
	def contact
		@contactform = ContactForm.new
	end
	def about
	end
	def submit
		
		@form = ContactForm.new(form_params)
	      if @form.valid?
		    @form.deliver!  
	        redirect_to :back, notice: 'Successfully Sent' 
	      else
	    
	         redirect_to root_path
	      end
	end
    def for_diners
    end
    def for_restaurants
    end
	private
    def form_params
      params.require(:contact_form).permit(:message, :name,:email,:subject, :restaurant_owner, :employee, :member, :zip, :other, :parent)
    end
end
