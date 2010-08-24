require 'sower/dot'
module Sower
  module Dot # :nodoc:
    class Graph # :nodoc:
      # Initialize a Dot::Graph to generate a dot file
      def initialize(graph,tree = nil)
        @graph = graph
        @tree = tree || Sower::Design::Tree.new(@graph)
        @digraph = GraphViz.digraph("test") do |g|
          g[:rotate] = 0
          g[:rankdir] = "LR"
          g.node[:color]="#333333"
          g.node[:style]='rounded,filled'
          g.node[:shape]='record'
          g.node[:fontname]='Trebuchet MS'
          g.node[:fillcolor]='#294b76'
          g.node[:fontcolor]='white'

          g.edge[:color]="#666666"
          g.edge[:arrowhead]="open"
          g.edge[:fontname]="Trebuchet MS"
          g.edge[:fontcolor]='#a95487'
          g.edge[:fontsize]=11

        end
      end

      def draw(filename, format = :dot)
        @graph.nodes.each do |ident|
          label = @tree.leaves[ident].to_dot || ident
          @digraph.add_node(ident, :label => label )
          @graph.tsort_each_child(ident) do |child|
            edge = @graph.edges[ident][child]
            label = @tree.branches[edge.key].statements.to_sql if @tree.branches[edge.key]
            @digraph.add_edge(ident,child, :label => label)
          end
        end
        @digraph.output(format => filename)
      end
    end
  end
end
