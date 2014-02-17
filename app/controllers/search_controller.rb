class SearchController < ApplicationController
	
	def index
		if params[:search].present?
			@search  = Restaurant.solr_search do
				fulltext params[:search]
				if params[:cuisine_search].present?
					any_of do
						params[:cuisine_search].each do |tag|
							with(:cuisines_name, tag)
						end
					end
				end
				if params[:worker_role].present?
					any_of do
						params[:worker_role].each do |tag|
							with(:worker, tag)
						end
					end
				end
			end
			@restaurants = @search.results
			

		else
			@search  = Restaurant.solr_search do
				if params[:cuisine_search].present?
				with(:cuisines_name, params[:cuisine_search])
				end

				if params[:worker_role].present?
				with(:worker, params[:worker_role])
				end

			end
		    @restaurants = @search.results
		end	
	end
end




###################################

#if params[:search].present?
#			@search  = Restaurant.solr_search do
#				fulltext params[:search]
#				if params[:cuisine_search].present?
#					any_of do
#						params[:cuisine_search].each do |tag|
#							with(:cuisines_name, tag)
#						end
#					end
#				end
#			end
#			@restaurants = @search.results
#
#
#		else
#			@search  = Restaurant.solr_search do
#				if params[:cuisine_search].present?
#				fulltext params[:search]
#				with(:cuisines_name, params[:cuisine_search])
#				end
#			end
#		    @restaurants = @search.results
#		end