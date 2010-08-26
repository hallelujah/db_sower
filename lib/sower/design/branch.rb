module Sower
  module Design
    # This provides a wrapper class to Sower::Edge
    # It is stateable, that says it can store statements relationships between leaves
    class Branch
      include Sower::Relation::Stateable

      attr_reader :edge

      def initialize(edge)
        @edge = edge
      end

      def attributes_for_leaf(leaf)
        if self.statement
          self.statement.attributes[leaf.table] 
        else
          []
        end
      end
    end
  end
end
