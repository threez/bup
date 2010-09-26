class Bup::Application
  # returns the path to the configuration file template
  def self.config_template
    File.join(File.dirname(__FILE__), "..", "..", "template", "bup.conf")
  end
  
  # returns tthe filename for the application configuration
  def filename
    File.join((ENV["BUP_DIR"] || File.join(ENV["HOME"], ".bup")), "config")
  end
  
  # returns the configuration
  def config
    if File.exist? filename
      @config ||= Bup::Config.load(filename)
    else
      error("bup is can't find config. Please run #{$0} init")
    end
  end
  
  # shows the usage on the command line
  def show_usage!
    puts "bup - easy backup - version #{Bup::Version}"
    puts "usage: #{$0} <command> [options]"
    puts "  init            initialize the directories and configuration"
    puts "  edit            edit configuration with your favourite editor"
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
        Bup::Commands.init(self)
      when "edit"
        Bup::Commands.edit(self)
      when "create"
        name = shift_or_error("no name specified!")
        Bup::Commands.create(self, name)
      when "config"
        Bup::Commands.config(self)
      when "list"
        Bup::Commands.list(self)
      when "restore"
        name = shift_or_error("no name specified!")
        Bup::Commands.restore(self, name)
      when "cron"
        Bup::Commands.cron(self)
      when "version"
        show_usage!
      else
        error "command #{command} is unknown!"
      end
    else
      error "no command specified!"
    end
  rescue Bup::Config::IntervalException => ex
    STDERR.puts "[interval] error in the configuration: #{ex}"
    clean_trace ex
    exit 10
  rescue Bup::Config::DuplicateEntryException => ex
    STDERR.puts "[duplicate] error in the configuration: #{ex}"
    clean_trace ex
    exit 11
  rescue Bup::Config::MissingValueException => ex
    STDERR.puts "[missing value] error in the configuration: #{ex}"
    clean_trace ex
    exit 12
  end
  
private
  
  # returns the trace of the config
  def clean_trace(exception)
    trace = exception.backtrace.select { |l| l.match(filename) }
    file, line, *rest = trace.first.split(":")
    STDERR.puts "file #{file} at line #{line}"
  end
end
