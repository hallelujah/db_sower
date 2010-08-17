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
end
