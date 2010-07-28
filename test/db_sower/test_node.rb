require 'helper'
class DbSower::TestNode < Test::Unit::TestCase

  def setup
    @seed = DbSower::Seed.new
  end

  def test_new
   node = DbSower::Node.new(@seed, :achats, :identifier => :aimfar_prod)
   assert_equal :achats, node.name
   assert_equal({:identifier => :aimfar_prod}, node.options)
  end

  def test_conditions
   node = DbSower::Node.new(@seed, :achats, :identifier => :aimfar_prod)
   node.where({:status => [-1,1]})
   assert_equal [DbSower::Conditional::Condition.new({:status => [-1,1]})], node.conditions
  end
end
