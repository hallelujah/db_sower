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

    should "return nil when sent #to_sql" do
      assert_nil @users.to_sql
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
      assert_nil @users.statement
      assert_respond_to @users, :where
      assert_same @users, @users.where(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statement
    end

    should "respond to and" do
      assert_nil @users.statement
      assert_respond_to @users, :and
      assert_same @users, @users.and(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statement
    end

    should "respond to or" do
      assert_nil @users.statement
      assert_respond_to @users, :or
      assert_same @users, @users.or(@users[:client_id].eq(@clients[:id]))
      assert_not_nil @users.statement
    end

    should "respond to has_branches?" do
      assert_respond_to @users, :has_branches?
      assert_false @users.has_branches?
      @users.depends_on(@clients)
      assert_true @users.has_branches?
    end

    should "respond to branches" do
      assert_respond_to @users, :branches
      @users.depends_on(@clients)
      assert_equal [@users.tree.branches[[@users,@clients]]], @users.branches
    end
  end
end
