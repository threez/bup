require 'net/ftp'

class Bup::Locations::Ftp

  attr_accessor :opts, :ftp
  
  def initialize(options = {})
    @opts = options
    connect
  end

  def prefix(basename)
    File.join(@opts[:root], basename)
  end

  def disconnect 
    @ftp.close if not @ftp.nil? and not @ftp.closed?
  end

  def connect 
    @ftp = Net::FTP.new(
      @opts[:host], 
      @opts[:user], 
      @opts[:password]) if @ftp.nil? || @ftp.closed?
  end

  def mkdir(dir)
    connect    
    @ftp.mkdir(prefix(dir))
  end
  
  def rmdir(dir)
    connect
    @ftp.rmdir(prefix(dir))
  end
  
  def ls(dir = ".")
    connect
    @ftp.chdir(prefix(dir)) if dir != "."
    @ftp.nlst
  end

  def cp(src, dest = ".")
    connect 
    @ftp.chdir(prefix(dest))
    @ftp.putbinaryfile(src)
  end

  def rm(file)
    connect
    @ftp.delete(prefix(file))
  end
  
end

