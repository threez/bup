# initalize the application constants
module Bup
  module Locations
    class LocationException < Exception; end
  end
end

# load the application files
path = File.expand_path(File.dirname(__FILE__))
for file in %w{time commands config dar version application scheduler} do
  require File.join(path, "bup", file)
end
for location in Dir["#{path}/bup/locations/*.rb"] do
  require location
end
