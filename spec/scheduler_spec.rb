require File.join(File.dirname(__FILE__), "spec_helper")

# mock the application with an sample log
app = Object.new
def app.log_filename
  File.join(File.dirname(__FILE__), "examples", "test.log")
end
# mock the application without a log
app_without_log = Object.new
def app_without_log.log_filename
  "/tmp/test-#{Time.now}.log"
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
  it "should make a full backup when the log is empty" do
    @scheduler = Bup::Scheduler.new(app_without_log)
    @scheduler.next_type("config", Time.now).should == :full
  end
  
  it "should make a differetial backup after min of a week" do
    @scheduler = Bup::Scheduler.new(app)
    time = Time.at(1285959710)
    @scheduler.next_type("config", time + 1.week).should == :differential
    @scheduler.next_type("config", time + 2.weeks).should == :differential
  end
  
  it "should make a incremental backup" do
    @scheduler = Bup::Scheduler.new(app)
    time = Time.at(1285959710)
    @scheduler.next_type("config", time + 1.day).should == :incremental
    @scheduler.next_type("config", time + 2.day).should == :incremental
  end
end
