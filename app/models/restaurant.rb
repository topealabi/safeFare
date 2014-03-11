class Restaurant < ActiveRecord::Base
	mount_uploader :logo, ImageUploader

  mount_uploader :image, PictureUploader
  # VALID_STATES = ['CA']

  #  	# State.all.each do |state| 
  #  	# 	VALID_STATES << state.abbreviation
  #  	# end
  scope :pending, where(approved:false)
	validates_presence_of :name, :address, :city, :zip

 
  # validates_inclusion_of :state,
  #   in: VALID_STATES
  validates_numericality_of :total_employees
 	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create
  validates :name, uniqueness: {scope: :user_id}, presence: true
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

  geocoded_by :restaurant_location
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }



  def restaurant_location 
    [address, city, state, zip].compact.join(', ')
  end

  searchable do
    text :name 
    text :address
    text :tags                        
    string :city                              
    string :state
    integer :zip                       
    text :description
    boolean :kid_friendly
    boolean :approved
    double :latitude
    double :longitude
    latlon(:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    string :cuisines_name, :multiple => true do
      cuisines.map { |cuisine| cuisine.name}
    end
    string :hood_name, :multiple => true do
      neighborhoods.map { |neighborhood| neighborhood.name}
    end
    string :worker, :multiple => true do
      z = aware_employees.map  do |emp|
        emp.roles.map do |r|
          r.role
        end
      end
      z.flatten
    end
  end

end
