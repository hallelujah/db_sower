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
        @tree.branches.select{|k,v| k.first == @node.identity}.values
      end

      def nodes
        @tree.graph.head_nodes_of(@node)
      end

      def inspect
        "<#<#{self.class}:0x#{(self.object_id * 2).to_s(16)}>"
      end
    end
  end
end
