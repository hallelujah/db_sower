require 'helper'
require 'sower/graph'
class TestGraph < Test::Unit::TestCase

  def setup
    assert(@graph = Sower::Graph.new) 
  end

  context "A Graph instance" do
    should "respond to nodes" do
      assert_respond_to @graph, :nodes
    end
    should "return an Array when sent #nodes" do
      assert_instance_of Array, @graph.nodes
    end
  end

  context "Graph class" do
    should "respond to draw" do
      assert_respond_to Sower::Graph, :draw
    end
  end

  context "draw method" do
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
