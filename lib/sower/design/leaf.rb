module Sower
  module Design
    # This class is used in Sower::Design::Tree
    # The most use case is in the #draw methodof a tree instance
    class Leaf
      attr_reader :node, :tree, :table
      delegate :[], :to => :table

      include Sower::Relation::Stateable

      # Initialize with a node and a tree
      # Construct a table that stores the [] methods
      def initialize(node, tree)
        @node = node
        @table = Sower::Relation::Table.new(@node)
        @tree = tree
      end

      # Make a dependency : add a branch to tree with self and leaf
      def depends_on(leaf)
        @tree.add_branch(self,leaf)
      end

      # A simple method to use in GraphViz digraph label of Node
      def to_dot
        "<id> #{node.identity}||<text> #{statement.to_sql}"
      end

      def has_branches?
        branches.any?
      end

      def branches
        pattern = MagicPattern.new(self) do |tested,(k,v)|
          k.first == tested
        end
        @tree.branches.grep(pattern){|(t,h),b| b }
      end

    end
  end
end
