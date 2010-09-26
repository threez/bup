require 'ftools'

class Bup::Locations::Local
  def initialize(options = {})
    @opts = options
  end

  def prefix(basename) 
    File.join(@opts[:root], basename)
  end

  def cp(src, dest = ".")
    File.copy(src, prefix(dest))
  end
  
  def mkdir(dir)
    Dir.mkdir(prefix(dir))
  end
  
  def rmdir(dir)
    Dir.rmdir(prefix(dir))
  end
  
  def rm(file)
    File.delete(prefix(file))
  end
  
  def ls(dir = ".")
    Dir.entries(prefix(dir))
  end
end

