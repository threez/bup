require "yaml"

class Bup::Scheduler
  class Log
    def initialize(file_path)
      load!(file_path)
    end
    
    # iterate over each backup or each log entry
    def each(&block)
      @log.each(&block)
    end
    
  private
  
    # save the backup log
    def save!(file_path)
      File.open(file_path, "w") do |f|
        f.write(YAML.dump(@log))
      end
    end
    
    # load the backup entries
    def load!(file_path)
      if File.exist? file_path
        @log = YAML.load(File.read(file_path))
      else
        @log = {}
      end
    end
  end
  
  def initialize(app)
    @log = Log.new(app.log_filename)
  end
  
  # returns the next backup that should be made based on the log and the backup
  def next_type(backup, from = Time.now)
    
  end
  
  # returns the reference for a type if there is one, otherwise nil
  def reference(name, type)
    
  end
end
