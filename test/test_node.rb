require 'helper'
require 'sower/node'
class TestNode < Test::Unit::TestCase
  def setup
    assert(@node = Sower::Node.new('my_identity'))
  end

  context "A Node instance" do
    should "respond to identity" do
      assert_respond_to @node, :identity
    end

    should "respond to edges" do
      assert_respond_to @node, :edges
    end

    should "respond to condition" do
      assert_respond_to @node, :condition
    end

    should "return Condition when sent #condition" do
      assert_instance_of Sower::Condition, @node.condition
    end

    should "respond to add_condition!" do
      assert_respond_to @node, :add_condition!
    end

  end

  context "Node class" do
    should "respond to ident" do
      assert_respond_to Sower::Node, :ident
    end

    should "return identity when sent #ident" do
      assert_equal "creations", Sower::Node.ident('creations')
      assert_equal "creations", Sower::Node.ident(:identity => 'creations')
      assert_equal "my_identity", Sower::Node.ident(@node)
    end

  end
end
