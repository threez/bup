require File.join(File.dirname(__FILE__), "spec_helper")

describe Bup::Scheduler do
  before(:all) do
    @app = Mock::Application.new
    @app_without_log = Mock::ApplicationWithoutLog.new
  end
  
  it "should make a full backup when the log is empty" do
    @scheduler = Bup::Scheduler.new(@app_without_log)
    @scheduler.next_type("config", Time.now).should == :full
  end
  
  it "should make a differetial backup after min of a week" do
    @scheduler = Bup::Scheduler.new(@app)
    time = Time.at(1285959710)
    @scheduler.next_type("config", time + 1.week).should == :differential
    @scheduler.next_type("config", time + 2.weeks).should == :differential
  end
  
  it "should make a incremental backup" do
    @scheduler = Bup::Scheduler.new(@app)
    time = Time.at(1285959710)
    @scheduler.next_type("config", time + 1.day).should == :incremental
    @scheduler.next_type("config", time + 2.day).should == :incremental
  end
end
