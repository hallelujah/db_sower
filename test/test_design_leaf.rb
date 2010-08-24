require 'helper'
class TestDesignLeaf < Test::Unit::TestCase

  def setup
    graph = Sower::Graph.new
    assert(@tree = Sower::Design::Tree.new(graph))
    node = Sower::Node.new(:users)
    assert(@users = Sower::Design::Leaf.new(node,@tree))
    assert(@clients = Sower::Design::Leaf.new(node,@tree))
  end

  context "A Design::Leaf instance" do
    should "respond to table" do
      assert_respond_to @users, :table
      assert_instance_of Sower::Relation::Table, @users.table
    end

    should "respond to node" do
      assert_respond_to @users, :node
      assert_instance_of Sower::Node, @users.node
    end

    should "respond to []" do
      assert_respond_to @users, :[]
      assert_instance_of Sower::Relation::Attribute, @users[:id]
    end

    should "respond to tree" do
      assert_respond_to @users, :tree
      assert_instance_of Sower::Design::Tree, @users.tree
    end

    should "respond to depends_on" do
      assert_respond_to @users, :depends_on
    end

    should "link node argument to tree when sent #depends_on" do
      assert_equal 0, @tree.edges_size
      branch = @users.depends_on(@clients)
      assert_instance_of Sower::Design::Branch, branch
      assert_equal 1, @tree.edges_size
    end

    should "respond to where" do
      assert_nil @users.statements
      assert_respond_to @users, :where
      assert_same @users, @users.where(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statements
    end

    should "respond to and" do
      assert_nil @users.statements
      assert_respond_to @users, :and
      assert_same @users, @users.and(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statements
    end

    should "respond to or" do
      assert_nil @users.statements
      assert_respond_to @users, :or
      assert_same @users, @users.or(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statements
    end
  end
end
