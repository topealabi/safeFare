class HomeController < ApplicationController
	before_filter :authenticate_fare
	def index
	end
	def about
	end
	def sitemap
	end
	def contact
		@contactform = ContactForm.new
	end
	def about
	end
	def disclaimer
	end
	def submit
		
		@form = ContactForm.new(form_params)
	      if @form.valid?
		    @form.deliver!  
	        redirect_to :back, notice: "<h1 style='text-align:center'>A Message from FARE</h1>Thank you for getting in touch with us.  We will review your message and will respond shortly regarding your comments/inquiry.<br>
	        Sincerely,<br>
	        Food Allergy Research & Education (FARE)<br>
	        <br>
	        <span style='font-style:italic;''>FARE’s mission is to find a cure for food allergies and to keep individuals with food allergies safe and included. Learn more at  #{ActionController::Base.helpers.link_to "www.foodallergy.org", 'http://www.foodallergy.org'} </span>".html_safe
	      else
	        redirect_to :back, notice: 'Sorry, there was an error processing your form.  Please try again'
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
