module Bup::Dar

  def self.create(options = {})
    p options

    conf = options[:backup_config]
    ref = options[:reference]
    type = options[:type]

    # TODO 
    # a copy of the latest archive must always be kept locally as reference archive
    # store catalogs locally?
    # test archive integrity after creation
    # dar -c -R <root source> -s<slice size in megabyte> -aM -y -K<encryption key> -A <reference archive>
    # later: excludes, encryption
    # encrypt, slice, reference archiv, dateiname
    #
    #
    reference = "" + "-A #{ref}" if not ref.nil?
    slice = "" + "-s #{conf[:split]} -aSI" if not conf[:split].nil? 
    crypt = "" + "-K #{conf[:key]}" if not conf[:key].nil?
    dar_params = "-c #{conf[:archives_path]}/#{conf[:name]} -R #{conf[:root]} -y5 #{reference} #{slice} #{crypt}"

    system("dar #{dar_params}")
  end
  
  def self.restore(backup, options = {})
    p backup
    p options
  end
  
  def self.verify(backup, options = {})
    p backup
    p options
  end

  def self.test(options = {})
    # test archive integrity
  end

end

