module Sower

  # This class provides a utility to 
  class Graph

    def initialize
      @nodes = {}
    end

    def node(ident_or_node)
      ident = Node.ident(ident_or_node)
      @nodes[ident_or_node]
    end

    def nodes
      @nodes.values
    end

    class << self
      def draw(graph = self.new,&block)
        raise ArgumentError, "<graph> must be a Sower::Graph instance" unless self === graph
        graph.instance_exec(&block)
        graph
      end
    end

  end
end
