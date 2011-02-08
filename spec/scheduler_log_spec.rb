require File.join(File.dirname(__FILE__), "spec_helper")

describe Bup::Scheduler::Log do
  before(:all) do
    @app = Mock::Application.new
  end
  
  it "should be possible to load a backup log without errors" do
    Bup::Scheduler::Log.new(@app.log_filename)
  end
  
  it "should be possible to iterate over a test log" do
    log = Bup::Scheduler::Log.new(@app.log_filename)
    i = 0
    log.each do |k, v| 
      k.is_a?(String).should be_true
      v.is_a?(Hash).should be_true
      i += 1
    end
    i.should == 1
  end
end
