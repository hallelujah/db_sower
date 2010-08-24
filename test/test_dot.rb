require 'helper'
require 'sower/dot/graph'

class TestDot < Test::Unit::TestCase
  def setup
    assert @tail = Sower::Node.new('tail')
    assert @head1 = Sower::Node.new('head1')
    assert @head2 = Sower::Node.new('head2')
    assert @graph = Sower::Graph.new
    assert @digraph = Sower::Dot::Graph.new(@graph)
  end


  should "draw graph even cyclic dependency" do
    @graph.add_nodes @head1, @head2, @tail
    @graph.add_edge(@tail,@head1)
    @graph.add_edge(@head2,@tail)
    @graph.add_edge(@head1,@head2)
    assert_nothing_raised do
      @digraph.draw("cyclic.png", :png)
    end
  end


  should "draw" do
    @graph.add_nodes @head1, @head2, @tail
    @graph.add_edge(@tail,@head1)
    @graph.add_edge(@tail,@head2)
    assert_nothing_raised do
      @digraph.draw("normal.png", :png)
    end
  end


end

