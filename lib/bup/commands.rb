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

  # create a new backup
  def self.create(app, name)
    
  end
  
  def self.config(app)
  end
  
  def self.list(app)
  end
  
  def self.restore(app, name)
  end
  
  def self.cron(app)
  end
end
