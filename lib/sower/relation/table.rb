module Sower
  module Relation
    class Table
      attr_reader :attributes
      delegate :[], :to => :attributes

      include Sower::Relation::Stateable

      def initialize(node)
        @node = node
        @attributes = Hash.new{ |h,k| h[k.to_sym] = Sower::Relation::Attribute.new(self,k.to_sym)}
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
