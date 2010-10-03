$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "lib")

# load rspec
begin
  require "rspec"
rescue LoadError
  require "rubygems"
  gem "rspec", "2.0.0.beta.22"
  require "rspec"
end unless defined? describe

# load the application stack
require "bup"
