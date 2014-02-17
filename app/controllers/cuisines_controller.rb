class CuisinesController < ApplicationController

	def index
	    @search  = Cuisine.solr_search do
	      fulltext params[:cuisine_search]

	    end
	    @cuisines = @search.results
	end

end