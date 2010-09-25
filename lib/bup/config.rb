class Bup::Config
  attr_reader :locations, :backups
  
  class Location
    attr_reader :options, :type
    
    def initialize(type, options = {})
      @type = type
      @options = options
    end
  end
  
  class Backup
    attr_reader :options, :intervals
    
    def initialize(options = {}, &block)
      @options = options
      @intervals = []
      instance_eval(&block)
    end
    
    # definea a backup strategie and interval
    # time: the interval in seconds
    # type: either on of the following
    #   :full (full backup)
    #   :diff (differential backup)
    #   :inc  (incrementa backup)
    def every(time, type)
      @intervals << Strategie.new(time, type)
    end
  end
  
  class Strategie
    attr_accessor :time, :type
    
    def initialize(time, type)
      @time, @type = time, type
    end
  end
  
  # defines a ftp location using a name and the paramters.
  # usage: ftp name, options
  # possible options are:
  #   host: the host ip, ord dns
  #   user: the user to use for authentication
  #   passwd: the passwd to use for authentication
  #   root: the path to user
  def ftp(name, options = {})
    @locations[name] = Location.new(:ftp, options)
  end
  
  # defines a local location if your planning to put the backup on a different
  # hard drive or just for testing.
  # usage: local name, options
  # possible options are:
  #   root: the path to user
  def local(name, options = {})
    @locations[name] = Location.new(:local, options)
  end
  
  # defines a backup with name
  # usage: backup name, options
  # possible options are:
  #   to: the name of the location (e.g. "test" would be the local /tmp/backups)
  #   from: path to the location that should be backuped
  def backup(name, options = {}, &block)
    @backups[name] = Backup.new(options, &block)
  end
  
  # create a new configuration
  def initialize(&block)
    @locations = {}
    @backups = {}
    instance_eval(&block)
  end
  
  # reads the passed file
  def self.load(file)
    new do
      eval(File.read(file), binding, file)
    end
  end
end

class Fixnum
  def month
    self * 30.days
  end

  def week
    self * 7.days
  end
  
  def day
    self * 24.hours
  end
  
  def hour
    self * 60.minutes
  end
  
  def minute
    self * 60 # seconds
  end
  
  alias months month
  alias weeks week
  alias days day
  alias hours hour
  alias minutes minute
end

def month
  1.month
end

def week
  1.week
end

def day
  1.day
end

def hour
  1.hour
end

def minute
  1.minute
end
