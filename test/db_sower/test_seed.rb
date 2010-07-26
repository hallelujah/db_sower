require 'helper'
class DbSower::TestSeed < Test::Unit::TestCase

  def setup
    @seed = DbSower::Seed.new
    @seed.graft do 
      # Creations depends on achats
      creations.with(:achats).where(:achat_id => :id)
      # masques depends on creations
      masques.with(:creations).where(:id => :masque_id)
      achats.with(:campagnes).where(:campagne_id => :id)
      annonceurs(:database => :aimfar_prod, :table => :users).with(:roles, :name => 'annonceur').where(:role_id => :id)
      campagnes.with(:annonceurs).where(:annonceur_id => :id)
      agences(:database => :aimfar_prod, :table => :users).with(:roles, :name => 'agence').where(:role_id => :id)
      annonceurs.with(:agences).where(:annonceur_id => :id)
    end
  end

  def test_graft
    puts @seed.tsort.flatten
    # We declared 6 tables : creations, achats, masques, campagnes, users, roles
    #assert_equal 6, @seed.tables

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
  end
end
