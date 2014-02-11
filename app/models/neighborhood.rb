class Neighborhood < ActiveRecord::Base
  has_many :areas
  has_many :restaurants, through: :areas
  validates_presence_of :name
end
