require 'helper'
class TestRelationStateable < Test::Unit::TestCase
  class AnObject
    include Sower::Relation::Stateable
  end

  def setup
    @object = AnObject.new
    assert(node = Sower::Node.new(:node))
    assert(@table = Sower::Relation::Table.new(node))
    @attribute = Sower::Relation::Attribute.new(@table, :name)
    @value = Sower::Relation::Value.in(['john', 'edward'])
    @statement = Sower::Relation::Statement.new(@attribute,@value)
  end

  context "A Stateable object" do
    should "respond to statement" do
      assert_respond_to @object, :statement
      assert_nil @object.statement
      @object.where(@statement)
      assert_equal @statement, @object.statement
    end

    should "respond to where" do
      assert_respond_to @object, :where
    end

    should "respond to or" do
      assert_respond_to @object, :or
    end

    should "respond to and" do
      assert_respond_to @object, :and
    end
  end
end
