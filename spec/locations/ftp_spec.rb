require File.join(File.dirname(__FILE__), "..", "spec_helper")
require 'net/ftp'

describe Bup::Locations::Ftp do

  before(:all) do
    @loc = Bup::Locations::Ftp.new(
      :host => "",
      :user => "", 
      :password => "",
      :root => "backup")

    @tmp_folder = "test#{Time.now.to_i}"
  end

  after(:all) do
    @loc.disconnect
  end

  it "should establish a connection to remote location" do
    @loc.ftp.closed?.should eql false
  end

  it "should be possible to create and delete a folder" do
    @loc.ls.include?(@tmp_folder).should eql false
    @loc.mkdir(@tmp_folder)
    @loc.ls.include?(@tmp_folder).should eql true
    @loc.rmdir(@tmp_folder)
    @loc.ls.include?(@tmp_folder).should eql false
  end

  it "should be possible to upload a file" do
    file = File.new("/tmp/#{@tmp_folder}", "w")
    file.write("Hello World!")
    file.close

    @loc.ls.include?(@tmp_folder).should eql false 
    @loc.cp("/tmp/#{@tmp_folder}")
    @loc.ls.include?(@tmp_folder).should eql true
    @loc.rm(@tmp_folder)
    @loc.ls.include?(@tmp_folder).should eql false 
  end

  
end


