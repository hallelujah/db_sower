require 'helper'
class TestRelationAttribute < Test::Unit::TestCase
  def setup
    assert(users = Sower::Node.new(:users))
    assert(@users = Sower::Relation::Table.new(users))
    assert(@attribute = Sower::Relation::Attribute.new(@users,:name))
    assert_equal @attribute, @users[:name]
  end

  context "A Relation::Attribute instance" do
    should "respond to in" do
      assert_respond_to @attribute, :in
      assert_instance_of Sower::Relation::Statement, @attribute.in(['john','edward'])
    end

    should "respond to eq" do
      assert_respond_to @attribute, :eq
      assert_instance_of Sower::Relation::Statement, @attribute.eq('john')
    end

    should "respond to like" do
      assert_respond_to @attribute, :like
      assert_instance_of Sower::Relation::Statement, @attribute.like("john%")
    end
  end
end
