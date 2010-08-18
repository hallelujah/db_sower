module Sower

  # This is the main class to draw the relationships between nodes.
  # It is a directed graph so that we can topologically use strongly connected components.
  # Nodes can then be sorted by their relationships.
  class Graph

    attr_reader :edges

    def initialize
      @nodes = {}
      @edges = {}
    end

    # Retrieve a node in hash @\nodes
    # You can pass whatever argument as in Node.ident
    def node(ident_or_node)
      ident = Node.ident(ident_or_node)
      @nodes[ident_or_node]
    end

    # Return all nodes of the graph
    def nodes
      @nodes.values
    end

    # Connect two nodes with an edge.
    # You must pass in :
    #   - tail identity or a tail node
    #   - head identity or a head node
    #   - condition that linked tail and head
    def add_edge(tail,head,condition)
      edge = Sower::Edge.new(tail,head,condition)
      key = edge.key
      if @edges.has_key?(key)
        @edges[key].add_condition!(edge.condition)
      else
        @edges[key] = edge
      end
      @edges[key]
    end

    class << self
      # A wrapper method to use when configuring the graph
      def draw(graph = self.new,&block)
        raise ArgumentError, "<graph> must be a Sower::Graph instance" unless self === graph
        graph.instance_exec(&block)
        graph
      end
    end

  end
end
