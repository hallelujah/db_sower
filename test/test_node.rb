require 'helper'
require 'sower/node'
class TestNode < Test::Unit::TestCase
  context "A Node instance" do
    setup { assert(@node = Sower::Node.new('my_identity')) }

    should "respond to identity" do
      assert_respond_to @node, :identity
    end

    should "respond to edges" do
      assert_respond_to @node, :edges
    end

    should "respond to conditions" do
      assert_respond_to @node, :conditions
    end
  end

  context "Node class" do
    should "respond to ident" do
      assert_respond_to Sower::Node, :ident
    end

    should "return identity when sent #ident" do
      assert_equal "creations", Node.ident('creations')
      assert_equal "creations", Node.ident(:identity => 'creations')
      assert_equal "my_identity", Node.ident(@node)
    end

  end
end
