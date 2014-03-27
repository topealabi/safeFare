class SearchController < ApplicationController
	def results
		
		def whereat
			params[:city_search] = 'new york' if params[:city_search] == 'newyork'
			params[:city_search] = 'new jersey' if params[:city_search] == 'newjersey'
			params[:city_search] = 'new orleans' if params[:city_search] == 'neworleans'
			params[:city_search] = 'new mexico' if params[:city_search] == 'newmexico'
			params[:city_search] = 'new haven' if params[:city_search] == 'newhaven'
			params[:city_search] = 'new hampshire' if params[:city_search] == 'newhampshire'
			params[:city_search] = 'new england' if params[:city_search] == 'newengland'
			params[:city_search] = 'new bunswick' if params[:city_search] == 'newbrunswick'
			params[:city_search] = 'new rochelle' if params[:city_search] == 'newrochelle'	  

	      	[params[:address], params[:hood_search], params[:city_search], params[:state_search], params[:zip_search]].compact.join(', ')
	    end
	    def howfar
	    	if (params[:within].present?) 
	       		params[:within].to_i * 1.60934
	   		else
	   			50
	   		end
	    end
	    def words_to_boolean(value)
    		if value == 'true' 
    			true
    		elsif value == 'false'
    			false
    		else
    			nil
    		end
 		end
	   
		if params[:search].present?
			@search  = Restaurant.solr_search do
			with(:approved, :true)
				fulltext params[:search]
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)
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
				if params[:address].present? || params[:city_search].present? || params[:state_search].present? || params[:zip_search].present?
					with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				end

				if params[:hood_search].present?
					any_of do
						params[:hood_search].each do |tag|
							with(:hood_name, tag)
						end
					end
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				end

				if params[:for_kids].present?
					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end 
			end

			@restaurants = @search.results

		elsif params[:cuisine_search].present?
			@search  = Restaurant.solr_search do
				with(:approved, :true)
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)
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
				if params[:address].present? || params[:city_search].present? || params[:state_search].present? || params[:zip_search].present?
					if Geocoder.coordinates(whereat)
						with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
					end
				end

				if params[:hood_search].present?
					any_of do
						params[:hood_search].each do |tag|
							with(:hood_name, tag)
						end
					end
				end

				if params[:within].present?
					with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				end

				if params[:for_kids].present?
					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end 
			end
			@restaurants = @search.results
		
		elsif params[:address].present? || params[:city_search].present? || params[:state_search].present? || params[:zip_search].present?
				
			@search  = Restaurant.solr_search do
				with(:approved, :true)
				with(:location).in_radius(*Geocoder.coordinates(whereat), howfar)
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)
				
				if params[:hood_search].present?
					any_of do
						params[:hood_search].each do |tag|
							with(:hood_name, tag)
						end
					end
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

				if params[:for_kids].present?
					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end 
			end

			@restaurants = @search.results

		elsif params[:hood_search].present?
			@search = Restaurant.solr_search do
				with(:approved, :true)
				any_of do
					params[:hood_search].each do |tag|
						with(:hood_name, tag)
					end
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

				if params[:for_kids].present?
					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end 
			end
			
			@restaurants = @search.results
		
		elsif (params[:within].present?)
			@search  = Restaurant.solr_search do
				with(:approved, :true)
				with(:location).in_radius(request.location.latitude, request.location.longitude, howfar)
				order_by_geodist(:location, request.location.latitude, request.location.longitude )
				paginate(:page => params[:page] || 1, :per_page => 10)

				if params[:worker_role].present?
				with(:worker, params[:worker_role])
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				end

				if params[:for_kids].present?
					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end

			end

			 @restaurants = @search.results


		elsif (params[:worker_role].present?)
			@search  = Restaurant.solr_search do
				with(:approved, :true)
				with(:worker, params[:worker_role])
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)

				if params[:for_kids].present?

					with(:kid_friendly, words_to_boolean(params[:for_kids]))
				end
			end
			@restaurants = @search.results

		elsif params[:for_kids].present?
			@search  = Restaurant.solr_search do
				with(:approved, :true)
				
				with(:kid_friendly, words_to_boolean(params[:for_kids]))

				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)
			end
			@restaurants = @search.results

		else
			#@restaurants = Restaurant.near([request.location.latitude, request.location.longitude], 50)
			@search = Restaurant.solr_search do
				with(:approved, :true)
				order_by_geodist(:location, request.location.latitude, request.location.longitude)
				paginate(:page => params[:page] || 1, :per_page => 10)
			end
			@restaurants = @search.results
		end
		
	end
	
	def index

	end
	
end

 