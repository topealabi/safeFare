class RolesController < ApplicationController

	def index
	    @search  = Role.solr_search do
	      fulltext params[:worker_role]

	    end
	    @roles = @search.results
	end

end