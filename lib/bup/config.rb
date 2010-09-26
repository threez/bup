class Bup::Config
  class MissingValueException < Exception; end
  class DuplicateEntryException < Exception; end
  
  attr_reader :locations, :backups
  
  class Location
    attr_reader :name, :options, :type
    
    def initialize(name, type, options = {})
      @name = name
      @type = type
      @options = options
    end
  end
  
  class Backup
    attr_reader :name, :options, :intervals
    
    def initialize(name, options = {}, &block)
      @name = name
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
    check_for_options("%s undefined for ftp location #{name}", options, 
                      %w{host user passwd root})
    check_for_duplicate_location(name)
    @locations[name] = Location.new(name, :ftp, options)
  end
  
  # defines a local location if your planning to put the backup on a different
  # hard drive or just for testing.
  # usage: local name, options
  # possible options are:
  #   root: the path to user
  def local(name, options = {})
    check_for_options("%s undefined for local location #{name}", options, 
                      %w{root})
    check_for_duplicate_location(name)
    @locations[name] = Location.new(name, :local, options)
  end
  
  # defines a backup with name
  # usage: backup name, options
  # possible options are:
  #   to: the name of the location (e.g. "test" would be the local /tmp/backups)
  #   from: path to the location that should be backuped
  def backup(name, options = {}, &block)
    check_for_options("%s undefined for backup #{name}", options, 
                      %w{to from})
    check_for_duplicate_backup(name)
    @backups[name] = Backup.new(name, options, &block)
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
  
private
  
  # check if the backup already exist
  def check_for_duplicate_backup(name)
    if @backups[name]
      raise DuplicateEntryException.new "the backup #{name} is already defined"
    end
  end
  
  # check if the location already exist
  def check_for_duplicate_location(name)
    if @locations[name]
      raise DuplicateEntryException.new "the location #{name} is already defined"
    end
  end
  
  # check that all fields (array) are in the options hash
  def check_for_options(str, options, fields)
    for field in fields do
      raise MissingValueException.new(str % [field]) unless options[field.to_sym]
    end
  end
end
