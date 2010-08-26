require 'helper'
class TestInspectable < Test::Unit::TestCase
  def setup
    @klass = Class.new do
      def initialize(key,val)
        @key, @val = key,val 
      end
      include Sower::Inspectable
      inspectable :key, :val
    end
    @inspectable = @klass.new(:toto,:tata)
  end

  context "A Inspectable element" do
    should "return a well formated string when sent #to_s" do
      assert_equal "#<#{@klass.to_s} key: :toto, val: :tata>", @inspectable.to_s
      assert_equal "#<#{@klass.to_s} key: :toto, val: :tata>", @inspectable.inspect
    end
    should "alias inspect to to_s" do
      assert_alias_method @inspectable, :inspect, :to_s
    end
  end
end
