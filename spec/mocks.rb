module Mock
  # mock the application with an sample log and config
  class Application < Bup::Application
    def log_filename
      example_file "test.log"
    end
  
    def config_filename
      example_file "test.conf"
    end
  end

  # mock the application without a log
  class ApplicationWithoutLog < Mock::Application
    def log_filename
      example_file "this-file-doesnt-exist-#{Time.now}.log"
    end
  end
end
