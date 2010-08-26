module Sower
  module Relation
    class Attribute

      include Sower::Relation::Value
      Sower::Relation::Value::IDENTIFIERS.each_key do |m|
        class_eval <<-DEF
        def #{m.to_s}_with_statement(value)
          Sower::Relation::Statement.new(self,#{m.to_s}_without_statement(value))
        end
        alias_method_chain "#{m.to_s}", :statement
        DEF
      end

      attr_reader :key, :table
      def initialize(table, key)
        @table, @key = table, key
      end
      
      include Sower::Inspectable
      inspectable :table, :key

      def ==(other)
        other.table == self.table && other.key == self.key
      end

      def attributes
        {self.table => [self]}
      end

      def to_sql
        "`#{self.table.table_name}`.`#{self.key.to_s}`"
      end

    end
  end
end
