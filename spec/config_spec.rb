require File.join(File.dirname(__FILE__), "spec_helper")

sample_file = File.join(File.dirname(__FILE__), "..", "template", "bup.conf")

describe Bup::Config do
  it "should possible to load the example configuration" do
    config = Bup::Config.load(sample_file)
    config.locations.size.should == 2
    config.locations["example"].nil?.should == false
    config.locations["example"].options.should == {
      :passwd => "test", :user => "test", 
      :root => "/backups", :host => "example.com"
    }
    config.locations["test"].nil?.should == false
    config.locations["test"].options.should == { :root => "/tmp/backups" }
    config.backups["config"].options.should == { :to => "test", :from => "/etc" }
    config.backups["config"].intervals.size.should == 3
    config.backups["config"].intervals[0].type == :full
    config.backups["config"].intervals[1].type == :diff
    config.backups["config"].intervals[2].type == :inc
    config.backups["config"].intervals[0].type == 2592000
    config.backups["config"].intervals[1].type == 604800
    config.backups["config"].intervals[2].type == 86400
  end
end
