require "fileutils"

module Bup::Commands
  # create bup dir and add configuration file
  def self.init(app)
    unless File.exists? app.filename
      dir = File.dirname(app.filename)
      FileUtils.mkdir_p dir unless File.exist? dir
      FileUtils.cp(app.class.config_template, app.filename)
    else
      app.error "the configuration file '#{app.filename}' already exists!"
    end
  end
  
  # edit the configuration file with the default editor
  def self.edit(app)
    if File.exists? app.filename
      if editor = ENV["EDITOR"]
        system("#{editor} #{app.filename}")
      else
        app.error "the environment variable EDITOR is unset. Can't open editor!"
      end
    else
      app.error "the configuration file '#{app.filename}' doesn't exist!"
    end
  end

  # create a new backup with name
  def self.create(app, name)
    config = app.config
    if backup_config = config.backups[name]
      if location = config.locations[backup_config.options[:to]]
        # get next type and reference
        scheduler = Bup::Scheduler.new(app)
        type = scheduler.next_type(backup_config)
        reference = scheduler.reference(name, type)
        
        # create the backup
        backup = Bup::Dar.create :backup_config => backup_config, :type => type, 
                                 :reference => reference
        
        # TODO insert the backup into the log and push to location [vila]
      else
        app.error "the location '#{backup.options[:to]}' doesn't exist " \
                  "for backup '#{name}'"
      end
    else
      app.error "the backup configuration '#{name}' doesn't exist!"
    end
  end
  
  STRATEGIE_NAMES = {
    :full => "full backup",
    :diff => "differential backup",
    :inc => "incremental backup"
  }
  
  # show current configuration
  def self.config(app)
    config = app.config
    puts "Locations:"
    for name, location in config.locations do
      puts "  #{name} (#{location.type})"
      for key, value in location.options
        puts "    #{key}: #{value}"
      end
    end
    puts "Backups:"
    for name, backup in config.backups do
      puts "  #{name} (#{backup.options[:from]} ==> #{backup.options[:to]})"
      for interval in backup.intervals do
        name = STRATEGIE_NAMES[interval.type]
        puts "    create one #{name} every " \
             "#{distance_of_time_in_words(interval.time)}"
      end
    end
  end
  
  # show backups that have been made
  def self.list(app)
    log = Bup::Scheduler::Log.new(app.log_filename)
    for backup_name, backups in log do
      puts "#{backup_name}"
      # TODO implement list command
    end
  end
  
  # restore a named backuo
  def self.restore(app, name)
    # TODO implement restore command
  end
  
  # creates the contab based on the configuration
  def self.cron(app)
    # TODO implement cron command
  end
end
