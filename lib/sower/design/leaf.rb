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
        @tree.add_node(leaf.node)
        edge = @tree.add_edge(self.node,leaf.node)
        Sower::Design::Branch.new(edge)
      end

    end
  end
end
