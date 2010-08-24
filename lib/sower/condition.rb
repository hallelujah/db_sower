module Sower
  # This class provides all the logic to link nodes, edges, etc ...
  class Condition

    # This module helps on adding some useful methods to classes with conditional aspects.
    module Methods
      ##
      # :attr_reader: condition
      define_method :condition do
        @condition ||= Condition.new
      end

      # Append a condition purpose to condition
      def add_condition!(cond)
        condition << cond
      end

      def condition_empty?
        condition.empty?
      end
    end

    attr_reader :values

    delegate :empty?, :to => :values

    # You can use any Object which implements to_condition
    #   Sower::Condition.new(Object)
    #
    def initialize(cond = nil)
      @values = []
      self << cond if cond
    end

    # Append condition to the values
    def <<(cond)
      @values << cond
    end

    # Compare self with other
    # It returns true if values are the same
    def ==(other)
      other.is_a?(Sower::Condition) && other.values == self.values
    end
  end
end
