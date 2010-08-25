require 'helper'
class TestDesignTree < Test::Unit::TestCase
  def setup
    graph = Sower::Graph.new
    assert(@tree = Sower::Design::Tree.new(graph))
    @users = Sower::Design::Leaf.new(Sower::Node.new(:users),@tree)
    @clients = Sower::Design::Leaf.new(Sower::Node.new(:clients),@tree)
  end

  context "A Design::Tree instance" do
    should "respond to add_leaf" do
      assert_respond_to @tree, :add_leaf
    end

    should "respond to add_leaves" do
      assert_respond_to @tree, :add_leaves
    end

    should "add leaf method" do
      assert ! @tree.respond_to?(:users)
      @tree.add_leaves(@users,@clients)
      assert_respond_to @tree, :clients
      assert_respond_to @tree, :users
    end
  end

  context "A Design::Tree instance with :users, :clients" do
    setup do
      @tree.add_leaves(@users,@clients)
    end

    should "draw with users and clients" do
      sql = nil
      assert_nothing_raised do
        @tree.draw do
          users.where(users[:status].ne(0))
          users.where(users[:client_id].eq(4))
          users.depends_on(clients).where(users[:client_id].eq(clients[:id]))
        end
      end
      edge = Sower::Edge.new(@users.node.identity,@clients.node.identity)
      assert_equal "`users`.`client_id` = `clients`.`id`", @tree.branches[edge.key].statement.to_sql
      dot = Sower::Dot::Graph.new(@tree.graph,@tree)
      dot.draw("users_clients.png",:png)
    end
  end
end
