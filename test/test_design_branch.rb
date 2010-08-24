require 'helper'
class TestDesignBranch < Test::Unit::TestCase
  def setup
    graph = Sower::Graph.new
    assert(@tree = Sower::Design::Tree.new(graph))
    node = Sower::Node.new(:users)
    assert(@users = Sower::Design::Leaf.new(node,@tree))
    assert(@clients = Sower::Design::Leaf.new(node,@tree))
    edge = Sower::Edge.new(:users, :clients)
    assert(@branch = Sower::Design::Branch.new(edge))
  end

  context "A Design::Branch instance" do

    should "respond to statements" do
      assert_respond_to @branch, :statements
    end
    should "respond to where" do
      assert @branch.statements.empty?
      assert_respond_to @branch, :where
      assert_same @branch, @branch.where(@users[:client_id].eq(@clients[:id]))
      assert !@branch.statements.empty?
    end

    should "respond to and" do
      assert @branch.statements.empty?
      assert_respond_to @branch, :and
      assert_same @branch, @branch.and(@users[:client_id].eq(@clients[:id]))
      assert !@branch.statements.empty?
    end

    should "respond to or" do
      assert @branch.statements.empty?
      assert_respond_to @branch, :or
      assert_same @branch, @branch.or(@users[:client_id].eq(@clients[:id]))
      assert !@branch.statements.empty?
    end
  end
end
