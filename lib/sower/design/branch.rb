module Sower
  module Design
    class Branch
      include Sower::Relation::Stateable

      attr_reader :edge

      def initialize(edge)
        @edge = edge
      end
    end
  end
end
