require 'active_record'
require 'active_record/fixtures'
logfile = File.open(File.expand_path('../log/database.log',__FILE__), 'a')    
logfile.sync = true


ActiveRecord::Base.logger = Logger.new(logfile)

conf = YAML.load_file(File.expand_path('../config/db.yml',__FILE__))
ActiveRecord::Base.configurations = conf
begin
  ActiveRecord::Base.establish_connection(:db1)
rescue Exception => e
  "Warning db1 was not created, please run rake test:db:prepare"
end

class ActiveRecord::Migration
  def self.load_data(filename, dir = File.expand_path('../db/fixtures',__FILE__))
    Fixtures.create_fixtures(dir, filename)
  end

  def self.change_config(spec,&block)
    old_spec = ActiveRecord::Base.connection.instance_eval("@config")
    ActiveRecord::Base.establish_connection(spec)
    yield
    ActiveRecord::Base.establish_connection(old_spec)
  end
end
