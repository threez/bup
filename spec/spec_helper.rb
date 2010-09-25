$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

# load rspec
begin
  require "rspec"
rescue LoadError
  require "rubygems"
  require "rspec"
end

# load the application stack
require "bup"
