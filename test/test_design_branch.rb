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

    should "respond to statement" do
      assert_respond_to @branch, :statement
    end
    should "respond to where" do
      assert @branch.statement.nil?
      assert_respond_to @branch, :where
      assert_same @branch, @branch.where(@users[:client_id].eq(@clients[:id]))
      assert !@branch.statement.nil?
    end

    should "respond to and" do
      assert_nil @branch.statement
      assert_respond_to @branch, :and
      assert_same @branch, @branch.and(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @branch.statement
    end

    should "respond to or" do
      assert_nil @branch.statement
      assert_respond_to @branch, :or
      assert_same @branch, @branch.or(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @branch.statement
    end
  end
end
