module Sower
  class Condition

    attr_reader :values
    def initialize(condition)
      @values = [condition]
    end

    # Append condition to the values
    def <<(condition)
      @values << condition
    end
  end
end
