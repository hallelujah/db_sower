require 'helper'
class DbSower::TestDumpBackend < Test::Unit::TestCase
  fixtures :creations, :masques
  
  def setup
    @seed = DbSower::Seed.new
    @seed.graft(:identifier => :db1) do
      creations
      masques.with(:creations).where(:id => :masque_id)
    end
  end

  def test_to_sql
    db_backend = DbSower::DumpBackend.new(@seed, File.expand_path('config/db.yml',$test_root))
    creation = DbSower::Node.new(@seed,:creations)
    masque = DbSower::Node.new(@seed,:masques)
    edge = @seed.edge(masque,creation)
    c1 = creations(:creation1) 
    c2 = creations(:creation2) 
    m1 = masques(:masque1) 
    m2 = masques(:masque2) 

    c1.masque = m1
    c2.masque = m2

    c1.save
    c2.save

    assert_equal({:database => 'database1',:port => 3306, :host => 'localhost', :user => 'db_sower', :password => 'db_sower', :socket => '/var/run/mysqld/mysqld.sock' }, db_backend.credentials(creation))
    assert_equal({:database => 'database1',:port => 3306, :host => 'localhost', :user => 'db_sower', :password => 'db_sower', :socket => '/var/run/mysqld/mysqld.sock' }, db_backend.credentials(masque))

    assert_equal({:masque_id => [c1.id.to_s, c2.id.to_s]}, db_backend.values_at(edge, :head))
    assert_equal({:id => [c1.id.to_s, c2.id.to_s]}, db_backend.values_at(edge, :tail))

  end

end
