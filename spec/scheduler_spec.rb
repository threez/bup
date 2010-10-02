require File.join(File.dirname(__FILE__), "spec_helper")

# mock the application
app = Object.new
def app.log_filename
  File.join(File.dirname(__FILE__), "examples", "test.log")
end

describe Bup::Scheduler::Log do
  it "should be possible to load a backup log without errors" do
    Bup::Scheduler::Log.new(app.log_filename)
  end
  
  it "should be possible to iterate over a test log" do
    log = Bup::Scheduler::Log.new(app.log_filename)
    i = 0
    log.each do |k, v| 
      k.is_a?(String).should be_true
      v.is_a?(Hash).should be_true
      i += 1
    end
    i.should == 1
  end
end

describe Bup::Scheduler do
  before(:all) do
    @scheduler = Bup::Scheduler.new(app)
  end

  it "should be possible to get the next backup using the log" do
    #@scheduler.next_type(backup)
  end
end