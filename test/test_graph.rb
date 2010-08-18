require 'helper'
require 'sower/graph'
class TestGraph < Test::Unit::TestCase

  def setup
    assert(@graph = Sower::Graph.new)
  end

  context "A Graph instance" do
    should "respond to edges" do
      assert_respond_to @graph, :edges
    end

    should "return a Hash when sent #edges" do
      assert_instance_of Hash, @graph.edges
    end

    should "respond to nodes" do
      assert_respond_to @graph, :nodes
    end

    should "return an Array when sent #nodes" do
      assert_instance_of Array, @graph.nodes
    end

    should "respond_to add_edge" do
      assert_respond_to @graph, :add_edge
      assert_equal 3, @graph.method(:add_edge).arity
    end

    should "add and return an edge when sent #add_edge" do
      tail = Sower::Node.new('tail')
      head = Sower::Node.new('head')
      conditions = {'left_hand' => 'right_hand'}
      assert_instance_of Sower::Edge, @graph.add_edge(tail, head, conditions)
      assert_instance_of Sower::Edge, @graph.add_edge(tail.identity, head.identity, conditions)
      assert_instance_of Sower::Edge, @graph.add_edge(Sower::Node.ident(tail) , Sower::Node.ident(head), conditions)
    end

  end

  context "Graph class" do
    should "respond to draw" do
      assert_respond_to Sower::Graph, :draw
    end
  end

  context "Graph::draw method" do
    should "return the graph argument passed" do
      assert_equal @graph, Sower::Graph.draw(@graph){}
    end

    should "return an instance of graph" do
      assert_instance_of Sower::Graph, Sower::Graph.draw{}
    end

    should "be given a block" do
      assert_raise LocalJumpError do
        Sower::Graph.draw(@graph)
      end
    end

    should "accept only a graph instance in draw" do
      assert_raise ArgumentError do
        Sower::Graph.draw(Object.new)
      end
    end

    should "raise nothing if block given" do
      assert_nothing_raised do
        Sower::Graph.draw{}
      end
      assert_nothing_raised do
        Sower::Graph.draw(@graph){}
      end
    end
  end

end
