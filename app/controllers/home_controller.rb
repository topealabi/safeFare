class HomeController < ApplicationController
	def index
	end
	def about
	end
	def contact
		@contactform = ContactForm.new
	end
	def submit
		@form = ContactForm.new(form_params)
	      if @form.valid?
	       @form.deliver!
	        redirect_to root_path
	      else
	         redirect_to root_path
	      end
	end
	private
   def form_params
      params.require(:contact_form).permit(:message, :name,:email)
    end
end
