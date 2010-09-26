require "fileutils"

module Bup::Commands
  # create bup dir and add configuration file
  def self.init(app)
    unless File.exists? app.filename
      dir = File.dirname(app.filename)
      FileUtils.mkdir_p dir unless File.exist? dir
      FileUtils.cp(app.class.config_template, app.filename)
    else
      app.error "the configuration file #{app.filename} already exists!"
    end
  end
  
  # edit the configuration file with the default editor
  def self.edit(app)
    if File.exists? app.filename
      if ENV["EDITOR"]
        system(ENV["EDITOR"] + " #{app.filename}")
      else
        app.error "the environment variable EDITOR is unset. Can't open editor!"
      end
    else
      app.error "the configuration file #{app.filename} doesn't exists!"
    end
  end

  # create a new backup with name
  def self.create(app, name)
    
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
    
  end
  
  # restore a named backuo
  def self.restore(app, name)
    
  end
  
  # creates the contab based on the configuration
  def self.cron(app)
    
  end
end
