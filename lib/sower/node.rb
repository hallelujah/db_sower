module Sower
  class Node

    attr_reader :identity, :conditions

    def initialize(ident)
      @identity = ident
      @conditions = nil
    end

    def edges(graph)
      raise NotImplementedMethodError
    end

  end
end
