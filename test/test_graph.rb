require 'helper'
require 'sower/graph'
class TestGraph < Test::Unit::TestCase

  def setup
    assert(@graph = Sower::Graph.new)
    assert(@tail = Sower::Node.new('tail'))
    assert(@head = Sower::Node.new('head'))
  end

  context "A Graph instance" do
    should "respond to tsort_each_node" do
      assert_respond_to @graph, :tsort_each_node
    end

    should "respond to tsort_each_child" do
      assert_respond_to @graph, :tsort_each_child
    end

    should "implement tsort_each_child" do
      assert_nothing_raised NotImplementedError do
        @graph.tsort_each_child(''){}
      end
    end

    should "implement tsort_each_node" do
      assert_nothing_raised NotImplementedError do
        @graph.tsort_each_node{}
      end
    end

    should "iterate through nodes when sent #tsort_each_node" do
      i = 0
      @graph.tsort_each_node{ |n| assert_same(n,@graph.nodes[i]); i+=1}
    end

    should "iterate through edges keys when sent #tsort_each_child" do
      @graph.tsort_each_node do |ident|
        i = 0
        @graph.tsort_each_child(ident) do |child|
         assert_same @graph.edges[ident].keys[i], child
         i += 1
        end
      end
    end

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

    should "return a list of node identity when sent #nodes" do
      @graph.add_nodes @tail, @head
      assert_same_elements [Sower::Node.ident(@tail), Sower::Node.ident(@head)], @graph.nodes
    end

    should "respond_to add_edge" do
      assert_respond_to @graph, :add_edge
      assert_equal 3, @graph.method(:add_edge).arity
    end

    should "add and return an edge when sent #add_edge" do
      @graph.add_nodes @tail,@head
      conditions = {'left_hand' => 'right_hand'}
      assert_instance_of Sower::Edge, @graph.add_edge(@tail, @head, conditions)
      assert_instance_of Sower::Edge, @graph.add_edge(@tail.identity, @head.identity, conditions)
      assert_instance_of Sower::Edge, @graph.add_edge(Sower::Node.ident(@tail) , Sower::Node.ident(@head), conditions)
    end

    should "return node in @nodes when sent #add_node" do
      node = Sower::Node.new('node1')
      assert_equal [], @graph.nodes
      n = @graph.add_node(node)
      assert_equal node, n
      assert_equal [node.identity], @graph.nodes
      assert_equal node, @graph.node(node)
    end

    should "raise ArgumentError when sent #add_node without node" do
      assert_raise ArgumentError do
        @graph.add_node 'toto'
      end
    end

    should "raise NotDoesNotExistError if node was not added first when sent #add_edge" do
      assert_raise Sower::Graph::NodeDoesNotExistError do
        @graph.add_edge('tail','head',{})
      end
    end
  end

  context "Graph class" do
    should "respond to draw" do
      assert_respond_to Sower::Graph, :draw
    end

    should "include TSort" do
      assert_contains Sower::Graph.included_modules, TSort
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
