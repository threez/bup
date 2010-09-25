module Bup::Version
  MINOR = 0
  MAJOR = 0
  TINY  = 1
  
  def self.to_a
    [MAJOR, MINOR, TINY]
  end
  
  def self.to_s
    to_a.join(".")
  end
end
