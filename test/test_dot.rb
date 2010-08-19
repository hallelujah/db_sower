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


  def test_draw
    @graph.add_nodes @head1, @head2, @tail
    @graph.add_edge(@tail,@head1,nil)
    @graph.add_edge(@tail,@head2,nil)
    assert_nothing_raised do
      @digraph.draw("toto.png", :png)
    end
  end

end

