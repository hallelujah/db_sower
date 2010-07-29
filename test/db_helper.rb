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

Dir.glob(File.expand_path('../model/**/*.rb',__FILE__)).each do |lib|
  f = File.basename(lib)
  require(f)
end

class Test::Unit::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.expand_path("../db/fixtures",__FILE__)
  self.use_instantiated_fixtures = false
  self.use_transactional_fixtures = false
  # Ugly hook ... ActiveRecord::TestFixtures calls "setup :setup_fixtures"
  # But in test/unit >= 2.1.0 setup with no arguments will registers it with default options {:after => :append}
  # So we need to unregister it and re-register with :before => :prepend
  unregister_setup :setup_fixtures
  register_setup_method :setup_fixtures, :before => :prepend
end



