require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Bup::Locations::Local do
  before(:all) do
    tmp_dir = "/tmp"
    @loc = Bup::Locations::Local.new(:root => tmp_dir)
    @tmp_name = "test#{Time.now.to_i}"
  end

  def should_exist(name) 
    @loc.ls.include?(name).should eql true
  end

  def should_not_exist(name) 
    @loc.ls.include?(name).should eql false
  end

  it "should be possible to create and delete a folder" do
    should_not_exist(@tmp_name)
    @loc.mkdir(@tmp_name)
    should_exist(@tmp_name)
    @loc.rmdir(@tmp_name)
    should_not_exist(@tmp_name)
  end

  it "should be possible to upload a file" do
    File.exists?(@tmp_name).should eql false
    file = File.new(@tmp_name, "w")
    file.write("Hello World!")
    file.close

    should_not_exist(@tmp_name)
    @loc.cp(@tmp_name)
    should_exist(@tmp_name)
    @loc.rm(@tmp_name)
    should_not_exist(@tmp_name)

    File.delete(@tmp_name)
  end
end


