desc "Starts the ftp server for testing purposes"
task "ftp" do
  ftp = File.join(File.dirname(__FILE__), "spec", "helper", "ftpd.rb")
  sh "ruby #{ftp} -p 2100 -d"
end


require "rubygems"
require "spec/rake/spectask"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_files = Dir.glob('spec/**/*_spec.rb')
  t.spec_opts << '--diff --format d'
  #t.rcov = true
end

task :default => :spec