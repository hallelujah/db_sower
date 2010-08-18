require 'helper'
require 'sower/condition'
class TestCondition < Test::Unit::TestCase
  def setup
    assert(@condition = Sower::Condition.new({'left_hand' => 'right_hand'}))
  end

  context "A Condition instance" do
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
      @condition << {'titi' => 'toto'}
      assert_equal [{'left_hand' => 'right_hand'},{'titi' => 'toto'}], @condition.values

    end

  end
end
