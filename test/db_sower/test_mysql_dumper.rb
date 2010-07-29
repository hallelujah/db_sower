require 'helper'
class TestMysqlDumper < Test::Unit::TestCase

  def setup
    h = ActiveRecord::Base.configurations['db1']
    ident = DbSower::DumpBackend::Identifier.new(h)
    @dumper1 = DbSower::Dumpers::Mysql.new(ident,{:table => :creations, :conditions => "id=1"})
    @dumper2 = DbSower::Dumpers::Mysql.new(ident,{:table => :creations, :xml => nil})
    @dumper3 = DbSower::Dumpers::Mysql.new(ident,{:table => :creations, :to => 'filename.sql'})
  end

  def test_generate_conditions
    assert_equal ["--where",'"id=1"'], @dumper1.generate_conditions
    assert_equal [], @dumper2.generate_conditions
  end

  def test_generate_credential_options
    credentials = [
      ["--database",'database1'],
      ['--host','localhost'],
      ['--password','db_sower'],
      ['--port','3306'],
      ['--socket','/var/run/mysqld/mysqld.sock'],
      ['--user','db_sower']
    ]
    assert_equal credentials, @dumper1.generate_credential_options
    assert_equal credentials, @dumper2.generate_credential_options
  end

  def test_generate_mysql_dump_options
    assert_equal [["--table",'creations']], @dumper1.generate_mysqldump_options
    assert_equal [["--table",'creations'],["--xml"]], @dumper2.generate_mysqldump_options
  end

  def test_dump_options
    assert_equal ["--database database1","--host localhost", "--password db_sower", "--port 3306", "--socket /var/run/mysqld/mysqld.sock", "--user db_sower", "--result-file filename.sql", "--table creations"], @dumper3.dump_options

  end
end
