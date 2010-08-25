module Sower
  module Design
    class Leaf
      attr_reader :node, :tree, :table
      delegate :[], :to => :table

      include Sower::Relation::Stateable

      def initialize(node, tree)
        @node = node
        @table = Sower::Relation::Table.new(@node)
        @tree = tree
      end

      def depends_on(leaf)
        @tree.add_branch(self,leaf)
      end

      def to_dot
        "<id> #{node.identity}||<text> #{statement.to_sql}"
      end

    end
  end
end
