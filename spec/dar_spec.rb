require File.join(File.dirname(__FILE__), "spec_helper")

describe Bup::Dar do
  before(:all) do
    timestamp = Time.now.to_i
    @backup_root = "/tmp/bup-#{timestamp}"
    @archives_path = "/tmp/bup_archives-#{timestamp}"
  
    # create directories and testdata
    FileUtils.mkdir_p(@backup_root)
    FileUtils.mkdir_p(@archives_path)
    create_test_data(@backup_root)
  end

  after(:all) do
    # remove them afterwards
    FileUtils.rm_rf(@backup_root)
    FileUtils.rm_rf(@archives_path)
  end

  it "should possible to create a full backup" do
    conf = { :name => "config", :root => @backup_root, 
      :archives_path => @archives_path}
    
    Bup::Dar::create(:backup_config => conf, :type => :full)
    # TODO extract archive and compare files with original
    # make test data path relative to project [ruje]
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
