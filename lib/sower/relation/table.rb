module Sower
  module Relation
    class Table
      attr_reader :attributes
      delegate :[], :to => :attributes

      def initialize(node)
        @node = node
        @attributes = Hash.new{ |h,k| h[k.to_sym] = Sower::Relation::Attribute.new(self,k.to_sym)}
        @statements = []
      end

      def where(statement)
        @statements << Sower::Relation::AndStatement.new(self,statement)
        self
      end
      alias and where

      def or(statement)
        @statements << Sower::Relation::OrStatement.new(self,statement)
        self
      end

      def table_name
        @node.identity.to_s
      end

      def to_sql
        "1 = 1"
      end

    end
  end
end
