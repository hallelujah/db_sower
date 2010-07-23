module DbSower

  module Conditional
    class ConditionError < ArgumentError;end

    def self.included(base)
      base.class_eval do
        attr_reader :conditions
      end
    end

    def add_condition(cond)
      @conditions << cond
    end

    def where(cond=nil,&block)
      if block_given?
        yield(self)
      elsif cond
        add_condition(cond)
      else
        raise ConditionError, "Must provide a condition or a block"
      end
    end
  end

end
