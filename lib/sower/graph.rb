require 'tsort'
module Sower

  # This is the main class to draw the relationships between nodes.
  # It is a directed graph so that we can topologically use strongly connected components.
  # Nodes can then be sorted by their relationships.
  class Graph

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

    class << self
      # A wrapper method to use to configuring the graph
      def draw(graph = self.new,&block)
        raise ArgumentError, "<graph> must be a Sower::Graph instance" unless self === graph
        graph.instance_exec(&block)
        graph
      end
    end

  end
end
