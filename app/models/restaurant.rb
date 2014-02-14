class Restaurant < ActiveRecord::Base
	mount_uploader :logo, ImageUploader
  VALID_STATES = ['CA']

  	State.all.each do |state| 
  		VALID_STATES << state.abbreviation
  	end
  	
	validates_presence_of :name, :address, :city, :zip
  validates_inclusion_of :state,
    in: VALID_STATES
  validates_numericality_of :total_employees
 	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :name, uniqueness: true
 	belongs_to :user,
 	  inverse_of: :restaurants
	
  has_many :cuisines, through: :type_of_cuisines
  has_many :type_of_cuisines,
    dependent: :destroy
  
  has_many :neighborhoods, through: :areas
  has_many :areas,
    dependent: :destroy

  has_many :aware_employees,
   	inverse_of: :restaurant,
    dependent: :destroy 
  
  has_many :changeorders,
   	inverse_of: :restaurant,
    dependent: :destroy 


  accepts_nested_attributes_for :areas, :reject_if => lambda { |a| a[:neighborhood_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :aware_employees, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :type_of_cuisines, :reject_if => lambda { |a| a[:cuisine_id].blank? }, :allow_destroy => true

  searchable do
    text :name, :as => :name_textp, :boost => 5 
    text :address, :as => :name_textp                          
    text :city, :as => :name_textp                             
    text :state, :as => :name_textp                            
    text :email, :as => :name_textp                            
    text :phone, :as => :name_textp
    text :hours, :as => :name_textp
    text :website, :as => :name_textp
    text :facebook_url, :as => :name_textp
    text :twitter_url, :as => :name_textp
    text :allergy_eats_url, :as => :name_textp
    text :description

  end

end
