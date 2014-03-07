# # config/initializers/geocoder.rb
 Geocoder.configure(

#   # geocoding service (see below for supported options):
   :lookup => :google,

#   key: ENV['BING_GEOCODE_ID'],

#   # IP address geocoding service (see below for supported options):
#   :ip_lookup => :maxmind,

#   :maxmind => {service}

#   # geocoding service request timeout, in seconds (default 3):
   :timeout => 20,

#   # set default units to kilometers:
#   :units => :km,
 )