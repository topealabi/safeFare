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
				if ( (params[:addy]).present? || (params[:city]).present? || (params[:hood_search]).present? || (params[:state_search]).present? || params[:zip].present?)
					def whereat
				      [params[:addy], params[:city], params[:state_search], params[:hood_search], params[:zip]].compact.join(', ')
				    end
				    def howfar 
				       params[:within].to_i * 1.60934
				    end
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
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

				if ( (params[:addy]).present? || (params[:city]).present? || (params[:hood_search]).present? || (params[:state_search]).present? || params[:zip].present?)
					def whereat
				      [params[:addy], params[:city], params[:state_search], params[:zip]].compact.join(', ')
				    end
				    def howfar 
				       params[:within].to_i * 1.60934
				    end
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
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