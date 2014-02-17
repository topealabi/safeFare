class Cuisine < ActiveRecord::Base
  has_many :type_of_cuisines
  has_many :restaurants, through: :type_of_cuisines
  validates_presence_of :name

  searchable do 
  	text :name
  	string :restaurants
  end
end
