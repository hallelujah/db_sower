require 'helper'
class TestRelationValue < Test::Unit::TestCase
  def setup
    @in = Sower::Relation::Value::In.new(['john','edward'])
    @eq = Sower::Relation::Value::Eq.new('john')
    @like = Sower::Relation::Value::Like.new("john%")
  end

  context "Relation::Value" do
    should "respond to in" do
      assert_respond_to Sower::Relation::Value, :in
      assert_instance_of Sower::Relation::Value::In, Sower::Relation::Value.in(['john','edward'])
    end

    should "respond to like" do
      assert_respond_to Sower::Relation::Value, :like
      assert_instance_of Sower::Relation::Value::Like, Sower::Relation::Value.like("john%")
    end

    should "respond to eq" do
      assert_respond_to Sower::Relation::Value, :eq
      assert_instance_of Sower::Relation::Value::Eq, Sower::Relation::Value.eq(['john','edward'])
    end

    should "respond to gt" do
      assert_respond_to Sower::Relation::Value, :gt
      assert_instance_of Sower::Relation::Value::Gt, Sower::Relation::Value.gt(5)
    end

    should "respond to gte" do
      assert_respond_to Sower::Relation::Value, :gte
      assert_instance_of Sower::Relation::Value::Gte, Sower::Relation::Value.gte(5)
    end

    should "respond to lt" do
      assert_respond_to Sower::Relation::Value, :lt
      assert_instance_of Sower::Relation::Value::Lt, Sower::Relation::Value.lt(5)
    end

    should "respond to lte" do
      assert_respond_to Sower::Relation::Value, :lte
      assert_instance_of Sower::Relation::Value::Lte, Sower::Relation::Value.lte(5)
    end

    should "respond to ne" do
      assert_respond_to Sower::Relation::Value, :ne
      assert_instance_of Sower::Relation::Value::Ne, Sower::Relation::Value.ne(5)
    end

    should "respond to not_in" do
      assert_respond_to Sower::Relation::Value, :not_in
      assert_instance_of Sower::Relation::Value::NotIn, Sower::Relation::Value.not_in([1,2,3,4,5])
    end
  end
end
