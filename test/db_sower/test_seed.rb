require 'helper'
class DbSower::TestSeed < Test::Unit::TestCase

  def setup
    @seed = DbSower::Seed.new
    @seed.graft do 
      # Creations depends on achats
      creations.with(:achats).where(:achat_id => :id)
      # masques depends on creations
      masques.with(:creations).where(:id => :masque_id)
      achats.where(:status => [-1,1]).with(:campagnes).where(:campagne_id => :id)
      annonceurs(:database => :aimfar_prod, :table => :users).with(:roles).where(:role_id => :id, :"roles.name" => 'annonceur')
      campagnes.with(:annonceurs).where(:annonceur_id => :id)
      agences(:database => :aimfar_prod, :table => :users).with(:roles).where(:role_id => :id, :"roles.name" => 'agence')
      annonceurs.with(:agences).where(:annonceur_id => :id)
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
    @seed.each_strongly_connected_component_from(DbSower::Node.new(@seed,:creations)) do |nodes|
      node = nodes.first
      puts node.conditions.map(&:conditions)
    end
  end
end
