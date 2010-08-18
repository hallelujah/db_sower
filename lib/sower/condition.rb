module Sower
  class Condition

    attr_reader :values
    def initialize(condition)
      @values = [condition]
    end

    def <<(condition)
      @values << condition
    end
  end
end
