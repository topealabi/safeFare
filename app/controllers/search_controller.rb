class SearchController < ApplicationController
	def results
		
		#@restaurants = Restaurant.near(request.location.coordinates, 10)
		puts request.location.latitude
		puts request.location.longitude
		def whereat
	      	[params[:address], params[:hood_search], params[:city_search], params[:state_search], params[:zip_search]].compact.join(', ')
	    end
	    def howfar
	    	if (params[:within].present?) 
	       		params[:within].to_i * 1.60934
	   		else
	   			100
	   		end
	    end

		if params[:search].present?
			@search  = Restaurant.solr_search do

				fulltext params[:search]
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
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
				if params[:state_search].present?
					with(:state, params[:state_search])
				end

				if params[:city_search].present?
					with(:city, params[:city_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if params[:zip_search].present?
					with(:zip, params[:zip_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if (params[:address].present?)
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				end

				if params[:kid_friendly].present?
					any_of do
						params[:kid_friendly].each do |tag|
							with(:kids, tag)
						end
					end
				end
			end

			@restaurants = @search.results

		elsif params[:cuisine_search].present?
			@search  = Restaurant.solr_search do
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				any_of do
					params[:cuisine_search].each do |tag|
						with(:cuisines_name, tag)
					end
				end

				if params[:worker_role].present?
					any_of do
						params[:worker_role].each do |tag|
							with(:worker, tag)
						end
					end
				end
				
				if params[:state_search].present?
					with(:state, params[:state_search])
				end

				if params[:city_search].present?
					with(:city, params[:city_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if params[:zip_search].present?
					with(:zip, params[:zip_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if (params[:address].present?)
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				end

				if params[:kid_friendly].present?
					any_of do
						params[:kid_friendly].each do |tag|
							with(:kids, tag)
						end
					end
				end
			end
			@restaurants = @search.results
		
		elsif params[:state_search].present?
			@search  = Restaurant.solr_search do
				with(:state, params[:state_search])
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				if params[:city_search].present?
					with(:city, params[:city_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if params[:zip_search].present?
					with(:zip, params[:zip_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if (params[:address].present?)
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
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

		elsif params[:city_search].present?
			@search  = Restaurant.solr_search do
				
				with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				if params[:state_search].present?
					with(:state, params[:state_search])
				end

				if params[:zip_search].present?
					with(:zip, params[:zip_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if (params[:address].present?)
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
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


		elsif params[:zip_search].present?
			@search  = Restaurant.solr_search do
				with(:zip, params[:zip_search])
				with(:location).in_radius(*Geocoder.coordinates(whereat), 100)	
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				if params[:city_search].present?
					with(:city, params[:city_search])
					with(:location).in_radius(*Geocoder.coordinates(whereat), 100)
				end

				if params[:state_search].present?
					with(:state, params[:state_search])
				end

				if (params[:address].present?)
				    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
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

		elsif (params[:address].present?)
			@search  = Restaurant.solr_search do
			    with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
			    order_by_geodist(:location, request.location.latitude, request.location.longitude)

				if params[:worker_role].present?
				with(:worker, params[:worker_role])
				order_by_geodist(:location, request.location.latitude, request.location.latitude)
				end

				if params[:kid_friendly].present?
				with(:kids, params[:kid_friendly])
				order_by_geodist(:location, request.location.latitude, request.location.longitude )
				end

			end
		    
		    @restaurants = @search.results

		elsif (params[:within].present?)
			@search  = Restaurant.solr_search do
				with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				order_by_geodist(:location, request.location.latitude, request.location.longitude )

				if params[:worker_role].present?
				with(:worker, params[:worker_role])
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				end

			end

			 @restaurants = @search.results


		elsif (params[:worker_role].present?)
			puts request.location.latitude
			puts request.location.latitude
			@search  = Restaurant.solr_search do
				with(:worker, params[:worker_role])
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
			end
			@restaurants = @search.results

		else
			@restaurants = Restaurant.near(request.location, 50, :order => :distance)
		end

	end
	
	def index

	end
	
end

 