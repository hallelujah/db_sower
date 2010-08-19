module Sower
  # This class provides all the logic to link nodes, edges, etc ...
  class Condition

    # This module helps on adding some useful methods to classes with conditional aspects.
    module Methods
      ##
      # :attr_reader: condition
      define_method :condition do
        @condition ||= Condition.new(nil)
      end

      # Append a condition purpose to condition
      def add_condition!(cond)
        condition << condition
      end
    end

    attr_reader :values

    # You can use any Object which implements to_condition
    #   Sower::Condition.new(Object)
    #
    def initialize(condition)
      @values = [condition]
    end

    # Append condition to the values
    def <<(condition)
      @values << condition
    end

    def ==(other)
      other.is_a?(Sower::Condition) && other.values == self.values
    end
  end
end
