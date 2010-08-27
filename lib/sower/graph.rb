require 'tsort'
module Sower

  # This is the main class to draw the relationships between nodes.
  # It is a directed graph so that we can topologically use strongly connected components.
  # Nodes can then be sorted by their relationships.
  class Graph

    delegate :__define_node_method__, :__node_method_defined__?, :to => :@proxy

    class NodeDoesNotExistError < StandardError # :nodoc:
      def initialize(n = nil)
        m = "node <%s> does not exist" % n.inspect
        super(m)
      end
    end

    include TSort

    attr_reader :edges

    def initialize # :nodoc:
      @nodes = {}
      @edges = Hash.new{|h,k| h[k] = {}}
      @proxy = Proxy.new(self)
    end

    # A class that provides wrapper methods for nodes
    # This aims at easying the process
    class Proxy
      class Elemental

        attr_reader :element, :proxy
        protected :element, :proxy

        def initialize(elt,proxy)
          @element, @proxy = elt, proxy
        end

        def depends_on(elemental_node)
          raise NoMethodError unless @element.is_a?(Sower::Node)
          @proxy.graph.add_edge(@element,elemental_node.element)
        end

        def method_missing(*args)
          self.class.new(@element.__send__(*args), @proxy)
        end

        def to_sql
          @element.to_sql
        end
      end

      attr_reader :graph
      def initialize(graph)
        @graph = graph
        @methods_defined = Hash.new(false)
      end

      private

      def __node_method_defined__?(node)
        @methods_defined[node.identity]
      end

      def __define_node_method__(node)
        ident = node.identity
        instance_eval <<-DEF
          def #{ident}
            Elemental.new(@graph.node('#{ident}'),self)
          end
          DEF
          @methods_defined[ident] = true
      end
    end

    # Iterate through each node of the Graph
    # All the node must be reached
    def each_node(&block)
      nodes.each(&block)
    end

    # Iterate through each direct child (also called head) of the node
    def tsort_each_child(ident,&block) # :nodoc:
      @edges[ident].keys.each(&block)
    end

    # Retrieve the head nodes of a node
    def head_nodes_of(node)
      ns = []
      tsort_each_child(Node.ident(node)) do |ident|
        ns << @nodes[ident]
      end
      ns
    end

    # Retrieve the tail nodes of a node
    def tail_nodes_of(node)
      n = Node.ident(node)
      @nodes.values_at(*@edges.grep(MagicPattern.new(n){|tested,(k,v)| v.has_key?(tested) }){|k,v| k})
    end

    # Iterate through each node of the Graph
    # All the node must be reached
    alias tsort_each_node each_node

    # Iterate through edges 
    def each_edge(&block)
      @edges.values.map(&:values).flatten.each(&block)
    end

    # Returns the number of edges
    def edges_size
      @edges.values.map(&:values).flatten.size
    end


    # Retrieve a node in hash @\nodes
    # You can pass whatever argument as in Node.ident
    def node(ident_or_node)
      ident = Node.ident(ident_or_node)
      @nodes[ident]
    end

    # Add a Node to @nodes list
    # Returns it
    def add_node(n)
      raise ArgumentError, "<#{n}> must be a Sower::Node" unless n.is_a?(Sower::Node)
      unless __node_method_defined__?(n)
        __define_node_method__(n)
      end
      @nodes[n.identity] ||= n
    end

    # Add a list of nodes
    def add_nodes(*args)
      args.each{|n| add_node(n)}
      args
    end

    # Return all nodes of the graph
    def nodes
      @nodes.keys
    end

    # Connect two nodes with an edge.
    # You must pass in :
    #   - tail identity or a tail node
    #   - head identity or a head node
    def add_edge(tail,head)
      edge = Sower::Edge.new(tail,head)
      tail_ident,head_ident = edge.key
      raise NodeDoesNotExistError, tail_ident unless @nodes.has_key?(tail_ident)
      raise NodeDoesNotExistError, head_ident unless @nodes.has_key?(head_ident)
      if @edges[tail_ident].has_key?(head_ident)
        @edges[tail_ident][head_ident]
      else
        @edges[tail_ident][head_ident] = edge
      end
    end

    # A method to help drawing the tree
    # Uses a proxy so that all methods are kept safe
    # TODO : maybe it is a good idea to use BlankSlate or BasicObject
    # After all it is not a good idea since we use many methods like respond_to? and instance_eval
    def draw(&block)
      raise LocalJumpError unless block_given?
      @proxy.instance_eval(&block)
      self
    end

    class << self
      # A wrapper method to use to configuring the graph
      def draw(graph = self.new,&block)
        raise ArgumentError, "<graph> must be a Sower::Graph instance" unless self === graph
        graph.draw(&block)
        graph
      end
    end

  end
end
