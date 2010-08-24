require 'helper'
require 'sower/edge'
class TestEdge < Test::Unit::TestCase
  def setup
    assert(@edge = Sower::Edge.new('tail','head'))
  end

  context "An Edge instance" do
    should "respond to tail" do
      assert_respond_to @edge, :tail
    end

    should "return a Node identity when sent #tail" do
      assert_instance_of String, @edge.tail
      assert_equal Sower::Node.ident('tail'), @edge.tail
    end

    should "respond to head" do
      assert_respond_to @edge, :head
    end

    should "return a Node identity when sent #head" do
      assert_instance_of String, @edge.head
      assert_equal Sower::Node.ident('head'), @edge.head
    end

    should "respond to key" do
      assert_respond_to @edge, :key
    end

    should "return a couple of key when sent #key" do
      assert_equal [Sower::Node.ident('tail'),Sower::Node.ident('head')], @edge.key
    end

    should "be the same" do
      edge = Sower::Edge.new('tail','head')
      assert_equal edge, @edge
    end
  end
end
