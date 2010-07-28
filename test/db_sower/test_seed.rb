require 'helper'
class DbSower::TestSeed < Test::Unit::TestCase

  def setup
    @seed = DbSower::Seed.new
    @seed.graft(:identifier => :aimfar_prod) do 
      # Creations depends on achats
      creations.with(:achats).where(:achat_id => :id)
      # masques depends on creations
      masques.with(:creations).where(:id => :masque_id)
      achats.where(:status => [-1,1]).with(:campagnes).where(:campagne_id => :id)
      annonceurs(:table => :users).with(:roles).where(:role_id => :id, 'annonceur' => :name)
      campagnes.with(:annonceurs).where(:annonceur_id => :id)
      agences(:table => :users).with(:roles).where(:role_id => :id, 'agence' => :name)
      campagnes.with(:agences).where(:agence_id => :id)
    end
  end

  def test_graft
    # We declared 6 tables : creations, achats, masques, campagnes, users, roles
    assert_equal 6, @seed.tables.size

    # We declared 6 nodes : creations, achats, masques, campagnes, annonceurs, campagnes, roles
    assert_equal 7, @seed.nodes.size

    # We declared 7 edges :
    # creations -> achats
    # masques -> creations
    # achats -> campagnes
    # campagne -> annonceurs
    # annonceurs -> agences
    # annonceurs -> roles
    # agences -> roles
    assert_equal 7, @seed.edges_size
    # The order that allow to fetch all the tables
    assert_equal ['roles','agences','annonceurs','campagnes','achats','creations','masques'], @seed.tsort.flatten.map(&:node_alias)
  end


  def test_edges
    return
    puts
    @seed.each_strongly_connected_component do |nodes|
      node = nodes.first
      puts node.node_alias + " : " + node.table_name 
      puts node.columns.inspect
      node.each_edge do |from,edge|
        puts " - " + from.node_alias + " : " + from.table_name 
      end
    end
    puts
  end
end
