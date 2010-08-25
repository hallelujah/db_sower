require 'helper'
class TestRelationStatement < Test::Unit::TestCase
  def setup
    assert(users = Sower::Node.new(:users))
    assert(@users = Sower::Relation::Table.new(users))
    @attribute = Sower::Relation::Attribute.new(@users, :name)
    @value = Sower::Relation::Value.in(['john', 'edward'])
    @statement = Sower::Relation::Statement.new(@attribute,@value)
  end

  context "A Statement instance" do
    should "respond to and" do
      assert_respond_to @statement, :and
    end

    should "respond to or" do
      assert_respond_to @statement, :or
    end

    should "return a query String when sent #to_sql" do
      statement = @statement.where(@users[:id].ne(1).and(@users[:status].eq(1)))
      assert_kind_of Sower::Relation::Statement, statement
      sql = statement.or(@users[:login].like("su%")).to_sql
      assert_equal "((`users`.`name` IN ('john','edward')) \nAND ((`users`.`id` != '1') \nAND (`users`.`status` = '1'))) \nOR (`users`.`login` LIKE 'su%')", sql
    end

    should "respond to attributes" do
      assert_respond_to @statement, :attributes
    end

    should "return a Hash which keys are Relation::Table and values Relation::Attibute when sent #attributes" do
      assert_instance_of Hash, @statement.attributes
      statement = @statement.where(@users[:id].ne(1).and(@users[:status].eq(1)))
      assert statement.attributes.any?
      assert statement.attributes.all?{|k,v| k.is_a?(Sower::Relation::Table) && v.all?{|a| a.is_a?(Sower::Relation::Attribute)} }
    end

  end
end
