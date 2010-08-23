require 'helper'
class TestCondition < Test::Unit::TestCase
  def setup
    users = Sower::Node.new(:users)
    @users = Sower::Relation::Table.new(users)
    @attribute = Sower::Relation::Attribute.new(@users, :name)
    @value = Sower::Relation::Value.in(['john', 'edward'])
    @statement = Sower::Relation::Statement.new(@attribute,@value)
    assert(@condition = Sower::Condition.new)
  end

  context "A Condition instance" do
    should "condition #values empty when instantiated with no arguments" do
      assert(cond = Sower::Condition.new)
      assert cond.values.empty?
    end

    should "respond to << " do
      assert_respond_to @condition, :<<
    end

    should "respond to values" do
      assert_respond_to @condition, :values
    end

    should "return an Array when sent #values" do
      assert_instance_of Array, @condition.values
    end

    should "concat condition when sent #<<" do
      @condition << @statement
      assert_equal [@statement], @condition.values
    end

    should "be the same" do
      cond = Sower::Condition.new
      assert_equal cond, @condition
      cond << @statement
      @condition << @statement
      assert_equal cond, @condition

    end

  end
end
