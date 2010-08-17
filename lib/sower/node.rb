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

    class << self
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
      def ident_from_hash(hash)
        hash[:identity]
      end
    end

  end
end
