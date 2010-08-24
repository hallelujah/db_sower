module Sower
  module Design
    class Tree

      attr_reader :graph, :branches, :leaves
      delegate :each_node, :each_edge, :edges_size, :to => :graph

      def initialize(graph)
        @graph = graph
        @branches = {}
        @leaves = HashWithIndifferentAccess.new
      end

      def add_leaves(*leaves_array)
        leaves_array.each{|leaf| add_leaf(leaf)}
        self
      end

      def add_branch(tail,head)
        add_leaves(tail,head)
        edge = @graph.add_edge(tail.node, head.node)
        @branches[edge.key] ||= Sower::Design::Branch.new(edge)
      end

      def add_leaf(leaf) 
        unless leaf_method_defined?(leaf)
          define_leaf_method(leaf)
          @graph.add_node(leaf.node)
        end
        self
      end

      def draw(&block)
        instance_exec(&block)
        self
      end

      private

      def leaf_method_defined?(leaf)
        respond_to?(leaf.node.identity)
      end

      def define_leaf_method(leaf)
        ident = leaf.node.identity
        @leaves[ident] = leaf
        instance_eval <<-DEF
        def #{ident}
          @leaves['#{ident}']
        end
        DEF
      end

    end
  end
end
