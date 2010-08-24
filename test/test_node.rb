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

    should "return a Array of Edge when sent #edges" do
      graph = Sower::Graph.new
      tail = Sower::Node.new('tail')
      head = Sower::Node.new('head')
      other_tail = Sower::Node.new('other_tail')
      graph.add_nodes @node, tail, head, other_tail
      graph.add_edge(tail,head)
      graph.add_edge(other_tail,tail)
      assert_instance_of Array, tail.edges(graph, :head)
      assert_equal [], @node.edges(graph,:both)
      assert_equal [], @node.edges(graph,:tail)
      assert_equal [], @node.edges(graph,:head)
      assert_equal [Sower::Edge.new(tail,head)],tail.edges(graph, :head)
      assert_equal [Sower::Edge.new(other_tail,tail)],tail.edges(graph,:tail)
      assert_equal [Sower::Edge.new(tail,head), Sower::Edge.new(other_tail,tail)],tail.edges(graph)
      assert_equal [Sower::Edge.new(tail,head), Sower::Edge.new(other_tail,tail)],tail.edges(graph,:both)
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

    should "raise ArgumentError when sent #ident with disallowed argument" do
      assert_raise ArgumentError do
        Sower::Node.ident(Object.new)
      end
    end

  end
end
