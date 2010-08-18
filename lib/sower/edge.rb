require 'sower/condition'
module Sower
  # An edge is a relationship between two nodes
  # In directed graph you must provide a tail and a head
  # These nodes are linked via a \condition
  # \condition should not be blank since it aims at determining how this relationship is built.
  # However, you could provide a blank condition but it is weird
  class Edge

    attr_reader :tail, :head, :condition, :key

    # tail can be whatever argument to pass in Sower::Node.ident
    # head can be whatever argument to pass in Sower::Node.ident
    # condition can be whatever argument to pass in Sower::Condition.new
    def initialize(tail,head,condition)
      @tail = Sower::Node.ident(tail)
      @head = Sower::Node.ident(head)
      @condition = Sower::Condition.new(condition)
      @key = [@tail,@head]
    end

    # Append a condition purpose to condition
    def add_condition!(cond)
      @condition << condition
    end


  end
end