class Bup::Config
  class MissingValueException < Exception; end
  class DuplicateEntryException < Exception; end
  class IntervalException < Exception; end
  
  attr_reader :locations, :backups
  
  class Location
    attr_reader :name, :options, :type
    
    def initialize(name, type, options = {}, &block)
      @name = name
      @type = type
      @options = options
      instance_eval(&block) if block_given?
    end
    
    # add setter for all host, user, passwd and root
    def method_missing(m, *args, &block)
      if [:host, :user, :passwd, :root].include? m
        @options[m] = args.first
      else
        super(m, *args, &block)
      end
    end
  end
  
  class Backup
    attr_reader :name, :options, :intervals
    
    def initialize(name, options = {}, &block)
      @name = name
      @options = options
      @intervals = []
      instance_eval(&block) if block_given?
    end
    
    # add setter for all to, from, key and split
    def method_missing(m, *args, &block)
      if [:to, :from, :key, :split].include? m
        @options[m] = args.first
      else
        super(m, *args, &block)
      end
    end
    
    # define a backup strategie and interval
    # time: the interval in seconds
    # type: either on of the following
    #   :full (full backup)
    #   :diff (differential backup)
    #   :inc  (incrementa backup)
    def every(time, type)
      if time < minute || time % minute != 0
        raise IntervalException.new("time must be in minutes or higher")
      end
      @intervals << Strategie.new(time, type)
    end
    
    # short/long verisons of types
    
    def full; :full end
    def diff; :differential end
    alias differential diff
    def inc; :incremental end
    alias incremental inc
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
  def ftp(name, options = {}, &block)
    location(:ftp, %w{host user passwd root}, name, options, &block)
  end
  
  # defines a local location if your planning to put the backup on a different
  # hard drive or just for testing.
  # usage: local name, options
  # possible options are:
  #   root: the path to user
  def local(name, options = {}, &block)
    location(:local, %w{root}, name, options, &block)
  end
  
  # adds a location to the configuration
  def location(type, params, name, options = {}, &block)
    check_for_duplicate_location(name)
    location = Location.new(name, type, options, &block)
    check_for_options "%s undefined for #{type} location #{name}", 
                      location.options, params
    @locations[name] = location
  end
  
  # defines a backup with name
  # usage: backup name, options
  # possible options are:
  #   to: the name of the location (e.g. "test" would be the local /tmp/backups)
  #   from: path to the location that should be backuped
  def backup(name, options = {}, &block)
    backup = Backup.new(name, options, &block)
    check_for_duplicate_backup(name)
    check_for_options("%s undefined for backup #{name}", backup.options, 
                      %w{to from})
    @backups[name] = backup
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
