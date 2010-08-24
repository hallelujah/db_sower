module Sower
  module Design
    class Tree

      attr_reader :graph

      def initialize(graph)
        @graph = graph
      end

      def draw(&block)
        instance_exec(&block)
      end

      def method_missing(*args)
        @graph.__send__(*args)
      end

    end
  end
end
