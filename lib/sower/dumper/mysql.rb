module Sower
  module Dumper
    class Mysql

      def initialize(node, tree)
        @node, @tree = node, tree
      end

      def standalone?
        nodes.all?{|n| self.class.new(n,@tree).standalone?} && statements.nil?
      end

      def statements
        @tree.leaves[@node.identity].statements
      end

      def branches
        pattern = MagicPattern.new(@node.identity){|tested,(k,v)| tested == k.first}
        @tree.branches.grep(pattern) do |k,v|
          v
        end
      end

      # Fetches all nodes under this one
      def nodes
        @tree.graph.head_nodes_of(@node)
      end

      # Fetches all nodes upon this one
      def super_nodes
        @tree.graph.tail_nodes_of(@node)
      end

      # Fetches all tables in tree of node
      def tables
        pattern = MagicPattern.new(@node.identity) do |tested,(ident,leaf)|
          ident == tested
        end
        @tree.leaves.grep(pattern){|ident,leaf| leaf.table}
      end

      def inspect
        "<#<#{self.class}:0x#{(self.object_id * 2).to_s(16)}>"
      end
    end
  end
end
