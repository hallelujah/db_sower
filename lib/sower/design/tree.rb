module Sower
  module Design
    # This class provides all the logic
    # When initializing a Sower::Design::Tree, you must provide a Sower::Graph
    # The most important method of a Sower::Design::Tree is #draw :
    #   tree.draw do
    #     users.depends_on(clients).where(clients[:id].eq(users[:client_id]))
    #   end
    # This above does three things :
    #   - adds nodes users.node and clients.node to graph
    #   - adds a dependency between users and clients : in GraphViz we can represent it as users -> clients
    #   - constructs a dependency relationship between users and clients (`users`.`client_id` = `client`.`id`)
    class Tree

      attr_reader :graph, :branches, :leaves, :proxy
      delegate :each_node, :each_edge, :edges_size, :to => :graph
      delegate :__leaf_method_defined__? , :__define_leaf_method__, :to => :proxy

      # Initialize a tree with a graph design
      def initialize(graph)
        @graph = graph
        @branches = {}
        @leaves = HashWithIndifferentAccess.new
        @proxy = Proxy.new(self)
      end


      # Add leaves to the tree
      # Implicitly adds nodes to the graph
      def add_leaves(*leaves_array)
        leaves_array.each{|leaf| add_leaf(leaf)}
        self
      end

      # Add a branch between two leaves
      # Implicitly add edges to the graph
      def add_branch(tail,head)
        add_leaves(tail,head)
        edge = @graph.add_edge(tail.node, head.node)
        @branches[edge.key] ||= Sower::Design::Branch.new(edge)
      end

      # Add a leaf to the tree
      # Implicitly add node to the graph
      def add_leaf(leaf) 
        unless __leaf_method_defined__?(leaf)
          __define_leaf_method__(leaf)
          @graph.add_node(leaf.node)
        end
        self
      end

      # A method to help drawing the tree
      # Uses a proxy so that all methods are kept safe
      # TODO : maybe it is a good idea to use BlankSlate or BasicObject
      # After all it is not a good idea since we use many methods like respond_to? and instance_eval
      def draw(&block)
        @proxy.instance_eval(&block)
        self
      end

      # A Proxy class to use to store leaves methods
      class Proxy # < ActiveSupport::BasicObject # :nodoc:

        def initialize(tree)
          @tree = tree
          @methods_defined = ::Hash.new(false)
        end

        private

        def __leaf_method_defined__?(leaf)
          @methods_defined[leaf.node.identity]
        end

        def __define_leaf_method__(leaf)
          ident = leaf.node.identity
          @tree.leaves[ident] = leaf
          instance_eval <<-DEF
            def #{ident}
              @tree.leaves['#{ident}']
            end
          DEF
          @methods_defined[ident] = true
        end

      end

    end
  end
end
