require 'helper'
class TestDumperMysql < Test::Unit::TestCase
  def setup
    graph = Sower::Graph.new
    @tree = Sower::Design::Tree.new(graph)
    clients = Sower::Design::Leaf.new(c = Sower::Node.new(:clients),@tree)
    users = Sower::Design::Leaf.new(u = Sower::Node.new(:users),@tree)

    @tree.draw do
      users.depends_on(clients).where(users[:client_id].eq(clients[:user_id]))
    end
    @client_dumper = Sower::Dumper::Mysql.new(c,@tree)
    @user_dumper = Sower::Dumper::Mysql.new(u,@tree)
  end

  context "A Dumper::Mysql instance" do
    should "respond to standalone?" do
      assert_respond_to @client_dumper, :standalone?
    end

    should "return boolean if sent #standalone?" do
      assert_equal true, @client_dumper.standalone?
      @tree.draw do
        clients.where(clients[:status].eq(1))
      end
      assert_equal false, @client_dumper.standalone?
    end

    should "respond to inspect" do
      assert_respond_to @client_dumper, :inspect
      assert @client_dumper.inspect
    end

    should "respond to branches" do
      assert_respond_to @client_dumper, :branches
      assert @client_dumper.branches.empty?
      assert @user_dumper.branches.any?
    end

    should "respond to nodes" do
      assert_respond_to @client_dumper, :nodes
      assert @client_dumper.nodes.empty?
      assert @user_dumper.nodes.any?
    end

  end
end
