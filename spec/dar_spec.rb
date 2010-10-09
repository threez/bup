require File.join(File.dirname(__FILE__), "spec_helper")
require 'digest/sha1'
require 'find'

describe Bup::Dar do
  before(:all) do
    timestamp = Time.now.to_i
    @backup_root = "tmp/bup-#{timestamp}"
    @archives_path = "tmp/bup_archives-#{timestamp}"
    @dirs_tmp = Array.new 
    # create directories and testdata
    mkdir_tmp(@backup_root)
    mkdir_tmp(@archives_path)
    mkdir_tmp(@backup_root)
    create_test_data(@backup_root)
  end

  def mkdir_tmp(path)
    FileUtils.mkdir_p(path)
    @dirs_tmp << path
  end

  after(:all) do
    # remove testdata afterwards
    @dirs_tmp.each do |path|
      FileUtils.rm_rf(path)
    end
  end

  it "should possible to create a full backup" do
    conf = { :name => "config", :root => @backup_root, 
      :archives_path => @archives_path}
    
    Bup::Dar::create(:backup_config => conf, :type => :full)

    restored_path = Bup::Dar::restore(:overwrite => true, :silent => true, :backup_config => conf)
    @dirs_tmp << restored_path
    content_equals?(conf[:root], restored_path).should == true
  end

  # compares the files in orignal_path and restored_path by their SHA1 checksums
  # returns true if restored_path is an exact copy of original_path
  def content_equals?(original_path, restored_path)
    checksums = Hash.new

    [original_path, restored_path].each do |path|
      checksums[path.to_sym] = Array.new
      Find.find(path) do |f|
	checksums[path.to_sym] << Digest::SHA1.file(f).hexdigest if File.file?(f)
      end
      checksums[path.to_sym].sort
    end

    checksums[original_path.to_sym] == checksums[restored_path.to_sym]
  end

  # creates test data in the passed root
  def create_test_data(backup_path, count = 100, size = 200)
    count.times do |i|
      File.open("#{backup_path}/file#{i}.txt", 'w') do |f|
	      f.write(random_string(size))
	    end
    end
  end
  
  # returns a random string of ascii upperletter chars with the passed length
  def random_string(length)
    Array.new(length){65+rand(25)}.pack("c"*length)
  end
end
