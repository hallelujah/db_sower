require 'db_helper'
class Migrator
  def self.migrate
    ActiveRecord::Base.configurations.each do |k,v|
      ActiveRecord::Base.establish_connection(v.merge('database' => nil))
      ActiveRecord::Base.connection.execute("DROP DATABASE IF EXISTS #{v['database']}")
      ActiveRecord::Base.connection.execute("CREATE DATABASE #{v['database']}")
    end
    ActiveRecord::Base.establish_connection :db1
    migrator = ActiveRecord::Migrator.migrate(File.expand_path('../db/migrate',__FILE__),nil)
  end
end
