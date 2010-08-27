module Sower
  # An edge is a relationship between two nodes
  # In directed graph you must provide a tail and a head
  class Edge

    include Sower::Relation::Stateable

    attr_reader :tail, :head, :key

    # tail can be whatever argument to pass in Sower::Node.ident
    # head can be whatever argument to pass in Sower::Node.ident
    def initialize(tail,head)
      @tail = Sower::Node.ident(tail)
      @head = Sower::Node.ident(head)
      @key = [@tail,@head]
    end

    # Compare self with other
    def ==(other)
      other.is_a?(Sower::Edge) && [:key].all?{ |k| other.__send__(k) == self.__send__(k)}
    end

  end
end
