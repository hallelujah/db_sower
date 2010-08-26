module Sower
  module Relation
    # Ths class aims at providing utilities like
    # users = Sower::Relation::Table.new(node)
    # users[:id] #=> Sower::Relation::Attribute
    # The node stores all the credentials (database, host, username, password)
    class Table
      attr_reader :attributes
      delegate :[], :to => :attributes

      include Sower::Relation::Stateable

      def initialize(node)
        @node = node
        @attributes = Hash.new{ |h,k| h[k.to_sym] = Sower::Relation::Attribute.new(self,k.to_sym)}
      end

      def to_s
        "#<#{self.class.name} name: #{table_name}>"
      end
      alias inspect to_s

      def table_name
        @node.identity.to_s
      end

    end
  end
end
