module Sower
  # An edge is a relationship between two nodes
  # In directed graph you must provide a tail and a head
  # These nodes are linked via a \condition
  # \condition should not be blank since it aims at determining how this relationship is built.
  # However, you could provide a blank condition but it is weird
  class Edge

    include Sower::Condition::Methods

    attr_reader :tail, :head, :key

    # tail can be whatever argument to pass in Sower::Node.ident
    # head can be whatever argument to pass in Sower::Node.ident
    # condition can be whatever argument to pass in Sower::Condition.new
    def initialize(tail,head,condition)
      @tail = Sower::Node.ident(tail)
      @head = Sower::Node.ident(head)
      @condition = Sower::Condition.new(condition)
      @key = [@tail,@head]
    end

    # Compare self with other
    # It returns true if key and condition are the same
    def ==(other)
      other.is_a?(Sower::Edge) && [:key,:condition].all?{ |k| other.__send__(k) == self.__send__(k)}
    end

  end
end
