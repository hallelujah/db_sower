module Sower
  # A node is an entity that stores information
  # Each node of a graph must be unique, identified by identity.
  # A node can have some conditions
  class Node

    include Sower::Condition::Methods

    attr_reader :identity

    # You can use any argument of Node.ident
    #   Sower::Node.new(String)
    #   Sower::Node.new(Hash)
    #   Sower::Node.new(Node)
    #
    def initialize(ident)
      @identity = Node.ident(ident)
    end

    class EdgePattern #:nodoc:
      def initialize(n)
        @node = n
      end
      def ===(h)
        h.has_key?(@node.identity)
      end
    end

    # Retrieve edges of this node in a graph
    #   direction can be :tail, :head, or :both (default)
    def edges(graph,direction = :both)
      a = []
      case direction
      when :tail 
        pattern = EdgePattern.new(self)
        a += (graph.edges.values.grep(pattern){ |hash| hash[self.identity] } || [])
      when :head
        a += graph.edges[self.identity].values
      when :both 
        a += edges(graph,:head)
        a += edges(graph,:tail)
      end
      a
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
