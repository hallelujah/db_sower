module Sower
  module Relation
    class Statement
      # Initialialize a statement where attribute and values are used between the connector
      def initialize(attribute,value)
        @attribute = attribute
        @value = value
      end

      # Create a new AndStatement with self as attribute and statement as value
      # It is a simple chaining
      def where(statement)
        AndStatement.new(self, statement)
      end
      alias and where

      # Create a new OrStatement with self as attribute and statement as value
      # It is a simple chaining
      def or(statement)
        OrStatement.new(self,statement)
      end

      # Generate a SQL String well formatted
      # TODO SQL string must be handled by a SQL formatter ... no matter for now
      def to_sql
        [@attribute.to_sql,@value.to_sql].compact.join(' ')
      end

      # Return a Hash of attributes indexed by table
      def attributes
        [@attribute,@value].inject(Hash.new([])) do |memo,c|
          case c 
          when Sower::Relation::Statement
            memo.merge!(c.attributes){|k,v,n| v | n}
          when Sower::Relation::Attribute
            memo[c.table] |= [c]
          end
          memo
        end
      end

      protected
      # Generate brackets around the value of the yielded block
      def paren
        res = yield.to_s.strip
        res.empty? ? nil : "(#{res})"
      end

    end

    class AndStatement < Statement
      # Generate a SQL String well formatted
      # TODO SQL string must be handled by a SQL formatter ... no matter for now
      def to_sql
        [paren{@attribute.to_sql},paren{@value.to_sql}].compact.join(" \nAND " )
      end
    end

    class OrStatement < Statement
      # Generate a SQL String well formatted
      # TODO SQL string must be handled by a SQL formatter ... no matter for now
      def to_sql
        "(#{@attribute.to_sql}) \nOR (#{@value.to_sql})"
      end
    end

    module Stateable
      ##
      # :attr_reader: statements
      def statements
        @statements
      end

      # Generate a new Statement or AndStatement depending on statement.is_nil? and set statement to it.
      # Return self
      def where(statement)
        if statements.nil?
          @statements = Sower::Relation::Statement.new(@statements,statement)
        else
          @statements = Sower::Relation::AndStatement.new(@statements,statement)
        end
        self
      end

      # Generate a new AndStatement and set statement to it.
      # Return self
      def and(statement)
        @statements = Sower::Relation::AndStatement.new(@statements,statement)
        self
      end

      # Generate a new OrStatement and set statement to it.
      # Return self
      def or(statement)
        @statements = Sower::Relation::OrStatement.new(@statements,statement)
        self
      end

      # Just return a nil value when invoking #to_sql for Stateable objects.
      def to_sql
        nil
      end
    end

  end
end
