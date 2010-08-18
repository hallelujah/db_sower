module Sower
  # A node is an entity that stores information
  # Each node of a graph must be unique, identified by identity.
  # A node can have some conditions
  class Node

    attr_reader :identity, :conditions

    def initialize(ident)
      @identity = ident
      @conditions = nil
    end

    # Retrieve edges of this node in a graph
    #   direction can be :tail, :head, or :both (default)
    def edges(graph,direction = :both)
      raise NotImplementedMethodError
    end

    class << self
      # Determine identity of a node
      #   identity_or_node can be a Hash, String or Node 
      def ident(identity_or_node)
        case identity_or_node
        when Hash
          ident_from_hash(identity_or_node)
        when String
          identity_or_node
        when ::Sower::Node
          identity_or_node.identity
        else
          raise ArgumentError,"Must be a Sower::Node, a Hash or a String"
        end
      end

      protected ### PROTECTED ###
      # TODO must implement more cases
      def ident_from_hash(hash)
        hash[:identity]
      end
    end

  end
end
