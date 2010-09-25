# initalize the application constants
module Bup
  module Locations
    class LocationException < Exception; end
  end
end

# load the application files
path = File.expand_path(File.dirname(__FILE__))
for file in %w{commands config dar version application} do
  require File.join(path, "bup", file)
end
for location in Dir["#{path}/*.rb"] do
  require location
end
