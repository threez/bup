class Bup::Locations::Ftp
  require 'net/ftp'

  attr_accessor :opts, :ftp
  
  def initialize(options = {})
    @opts = options
    connect
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
    @ftp.mkdir(dir)
  end
  
  def rmdir(dir)
    connect
    @ftp.rmdir(dir)
  end
  
  def ls
    connect
    @ftp.nlst
  end

  def cp(src, dest = ".")
    connect 
    @ftp.chdir(dest)
    @ftp.putbinaryfile(src)
  end

  def rm(file)
    connect
    @ftp.delete(file)
  end
  
end

