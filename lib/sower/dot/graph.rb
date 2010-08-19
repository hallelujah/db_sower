require 'sower/dot'
module Sower
  module Dot # :nodoc:
    class Graph # :nodoc:
      # Initialize a Dot::Graph to generate a dot file
      def initialize(graph)
        @graph = graph
        @digraph = GraphViz.digraph("test") do |g|
          g[:rotate] = 0
          g[:rankdir] = "LR"
          g.node[:color]="#333333"
          g.node[:style]='filled'
          g.node[:shape]='box'
          g.node[:fontname]='Trebuchet MS'
          g.node[:fillcolor]='#294b76'
          g.node[:fontcolor]='white'

          g.edge[:color]="#666666"
          g.edge[:arrowhead]="open"
          g.edge[:fontname]="Trebuchet MS"
          g.edge[:fontsize]=11

        end
      end

      def draw(filename, format = :dot)
        @graph.tsort.each do |ident|
          @digraph.add_node(ident, :label => ident)
          @graph.tsort_each_child(ident) do |child|
            @digraph.add_edge(ident,child)
          end
        end
        @digraph.output(format => filename)
      end
    end
  end
end
