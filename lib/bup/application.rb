class Bup::Application
  # returns tthe filename for the application configuration
  def filename
    File.join((ENV["BUP_DIR"] || File.join(ENV["HOME"], ".bup")), "config")
  end
  
  def config
    if File.exist? filename
      @config ||= Config.load(filename)
    else
      error("bup is can't find config. Please run #{$0} init")
    end
  end
  
  # shows the usage on the command line
  def show_usage!
    puts "bup - easy backup - version #{Bup::Version}"
    puts "Usage: #{$0} <command> [options]"
    puts "  init            initialize the directories and configuration"
    puts "  create <name>   create backup with name"
    puts "  config          show the current configuration"
    puts "  list            list all backups from the locations"
    puts "  restore <name>  restore backup with name"
    puts "  cron            write contab"
    puts "  version         returns the version and shows this help"
  end
  
  # displays an error on the command line
  # lines:: either a string or a list of strings
  def error(lines)
    if lines.respond_to? :each
      for line in lines do
        STDERR.puts line
      end
      show_usage!
      exit! 1
    else
      error([line])
    end
  end
  
  # errors if argv is empty
  def shift_or_error(line)
    error(line) if ARGV.empty?
    ARGV.shift
  end
  
  # parses the argurments and delegates to the corresponding commands
  def start!
    if command = ARGV.shift
      case command
      when "init"
        Bup::Commands.init
      when "create"
        name = shift_or_error("no name specified!")
        Bup::Commands.create(config, name)
      when "config"
        Bup::Commands.config(config)
      when "list"
        Bup::Commands.list(config)
      when "restore"
        name = shift_or_error("no name specified!")
        Bup::Commands.restore(config, name)
      when "cron"
        Bup::Commands.cron(config)
      when "version"
        show_usage!
      else
        error "command #{command} is unknown!"
      end
    else
      error "no command specified!"
    end
  end
end
