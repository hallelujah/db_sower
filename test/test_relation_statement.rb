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
    sql = statement.or(@users[:login].like("su%")).to_sql
    assert_equal "((`users`.`name` IN ('john','edward')) AND ((`users`.`id` != '1') AND (`users`.`status` = '1'))) OR (`users`.`login` LIKE 'su%')", sql
    end
  end
end
