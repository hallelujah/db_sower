require 'helper'
class DbSower::TestNode < Test::Unit::TestCase

  def setup
    @seed = DbSower::Seed.new
  end

  def test_new
   node = DbSower::Node.new(@seed, :achats, :database => :aimfar_prod)
   assert_equal :achats, node.name
   assert_equal({:database => :aimfar_prod}, node.options)
  end

  def test_conditions
   node = DbSower::Node.new(@seed, :achats, :database => :aimfar_prod)
   node.where("(client_id = :client_id AND status => :status) OR (status = 0 AND stopped_at >= '2010-06-01')")
   assert_equal [DbSower::Conditional::Condition.new("(client_id = :client_id AND status => :status) OR (status = 0 AND stopped_at >= '2010-06-01')")], node.conditions
  end
end
