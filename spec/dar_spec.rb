require File.join(File.dirname(__FILE__), "spec_helper")



describe Bup::Dar do

  before(:all) do
    timestamp = Time.now.to_i
    @backup_root = "/tmp/bup-#{timestamp}"
    @archives_path = "/tmp/bup_archives-#{timestamp}"
    create_test_data()
  end

  after(:all) do
    FileUtils.remove_dir(@backup_root)
    FileUtils.remove_dir(@archives_path)
  end

  it "should possible to create a full backup" do
    conf = { :name => "config", :root => @backup_root, 
      :archives_path => @archives_path}
    
    Bup::Dar::create(:backup_config => conf, :type => :full)

=begin
TODO 
 extract archive and compare files with original
 make test data path relative to project
=end

  end


  def create_test_data()
    Dir.mkdir(@backup_root)
    Dir.mkdir(@archives_path)
    (0..100).each do |i|
        File.open("#{@backup_root}/file#{i}.txt", 'w') do |f|
	   f.write(create_random_string(200))
	end
    end
  end

  def create_random_string(length)
    (0...length).map{65.+(rand(25)).chr}.join
  end
  
end
