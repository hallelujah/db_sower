require 'helper'
class TestMysqlDumper < Test::Unit::TestCase
  fixtures :creations, :masques

  def setup
    h = ActiveRecord::Base.configurations['db1']
    ident = DbSower::DumpBackend::Identifier.new(h)
    @dumper1 = DbSower::Dumpers::Mysql.new(ident,{:table => :masques, :conditions => "id=1"})
    @dumper2 = DbSower::Dumpers::Mysql.new(ident,{:table => :masques, :xml => true})
    @dumper3 = DbSower::Dumpers::Mysql.new(ident,{:table => :masques, :to => 'filename.sql'})
    @seed = DbSower::Seed.new
    @seed.graft(:identifier => :db1) do
      creations
      masques.with(:creations).where(:id => :masque_id)
    end
    @db_backend = DbSower::DumpBackend.new(@seed, File.expand_path('config/db.yml',$test_root))
    @creation = DbSower::Node.new(@seed,:creations)
    @masque = DbSower::Node.new(@seed,:masques)
    @edge = @seed.edge(@masque,@creation)
    @c1 = creations(:creation1) 
    @c2 = creations(:creation2) 
    @m1 = masques(:masque1) 
    @m2 = masques(:masque2) 
    @c1.masque = @m1
    @c2.masque = @m2
    @c1.save!
    @c2.save!
  end

  def test_generate_conditions
    assert_equal [["--where","'id=1'"]], @dumper1.generate_conditions
    assert_equal [], @dumper2.generate_conditions
  end

  def test_generate_credential_options
    credentials = [
      ["--default-character-set=latin1"],
      ["--host=localhost"],
      ['--password=db_sower'],
      ['--port=3306'],
      ['--socket=/var/run/mysqld/mysqld.sock'],
      ['--user=db_sower'],
      ['--add-drop-table'],
      ['--compact'],
      ['--compatible=mysql40'],
      ['--skip-comments'],
      ['--skip-opt'],
      ["database1"],
      ["masques"]
    ]
    assert_equal credentials, @dumper1.generate_credential_options
    assert_equal credentials, @dumper2.generate_credential_options
    assert_equal credentials, @dumper3.generate_credential_options
  end

  def test_generate_mysql_dump_options
    assert_equal [], @dumper1.generate_mysqldump_options
    assert_equal [["--xml"]], @dumper2.generate_mysqldump_options
  end

  def test_dump_options
    assert_equal ["--default-character-set=latin1", "--host=localhost", "--password=db_sower", "--port=3306", "--socket=/var/run/mysqld/mysqld.sock", "--user=db_sower", "--add-drop-table", "--compact", "--compatible=mysql40", "--skip-comments", "--skip-opt", "database1", "masques", ">> filename.sql"], @dumper3.dump_options
  end

  def test_command_line
    @dumper3.conditions = @db_backend.adapter(@masque).formatted_conditions(@db_backend)
    assert_equal ["/usr/bin/mysqldump", "--default-character-set=latin1", "--host=localhost", "--password=db_sower", "--port=3306", "--socket=/var/run/mysqld/mysqld.sock", "--user=db_sower", "--add-drop-table", "--compact", "--compatible=mysql40", "--skip-comments", "--skip-opt", "database1", "masques", "--where", "'(`masques`.`id` IN ('1','2'))'", ">> filename.sql"], @dumper3.command_line
  end
end
