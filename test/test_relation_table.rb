require 'helper'
class TestRelationTable < Test::Unit::TestCase
  def setup
    users = Sower::Node.new(:users)
    @graph = Sower::Graph.new
    @users = Sower::Relation::Table.new(users)
  end

  context "a Relation::Table instance" do
    should "respond to where" do
      assert_respond_to @users, :where
      assert_same @users, @users.where(@users[:status].eq(1))
    end

    should "respond to []" do
      assert_respond_to @users, :[]
      assert_instance_of Sower::Relation::Attribute, @users[:status]
    end
  end
end
