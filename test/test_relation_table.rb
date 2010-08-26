require 'helper'
class TestRelationTable < Test::Unit::TestCase
  def setup
    users = Sower::Node.new(:users)
    @graph = Sower::Graph.new
    @users = Sower::Relation::Table.new(users)
    assert @users.to_s
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

    should "chain statement" do
      @users.where(@users[:status].eq(1))
      @users.where(@users[:client_id].eq(4))
      @users.or(@users[:status].eq(0).and(@users[:client_id].ne(4)))
      assert_equal "((`users`.`status` = '1') \nAND (`users`.`client_id` = '4')) \nOR ((`users`.`status` = '0') \nAND (`users`.`client_id` != '4'))", @users.statement.to_sql
    end
  end
end
