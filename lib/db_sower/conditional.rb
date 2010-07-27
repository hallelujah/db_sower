module DbSower
  module Conditional

    class Condition

      attr_reader :conditions

      def ==(other)
        @conditions == other.conditions
      end

      def initialize(cond = {})
        @conditions = cond.clone
      end

      def keys
        @conditions.keys
      end

      def values
        @conditions.values
      end
    end

    def self.included(base)
      base.class_eval do
        attr_reader :conditions
      end
    end

    def where(conditions = {})
      @conditions << DbSower::Conditional::Condition.new(conditions)
      self
    end
  end
end
