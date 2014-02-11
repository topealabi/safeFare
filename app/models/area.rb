class Area < ActiveRecord::Base
	belongs_to :restaurant
	belongs_to :neighborhood
end
