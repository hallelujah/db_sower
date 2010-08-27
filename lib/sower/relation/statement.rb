module Sower
  module Relation
    class Statement
      # Initialialize a statement where attribute and values are used between the connector

      attr_reader :attribute, :value
      def initialize(attribute,value)
        @attribute = attribute
        @value = value
      end

      # Loose Equality function
      def ==(other)
        other.class == self.class && [@attribute,@value] == [other.attribute,other.value]
      end

      #def minimal?
      #  [@attribute,@value].none?{ |a| Sower::Relation::Statement === a}
      #end

      # Create a new AndStatement with self as attribute and statement as value
      # It is a simple chaining
      def where(state)
        AndStatement.new(self, state)
      end
      alias and where

      # Create a new OrStatement with self as attribute and statement as value
      # It is a simple chaining
      def or(state)
        OrStatement.new(self, state)
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
          when Sower::Relation::Statement, Sower::Relation::Attribute, Sower::Relation::Value::Base
            memo.merge!(c.attributes){|k,v,n| v | n}
          end
          memo
        end
      end

      include Sower::Inspectable
      inspectable :attribute, :value

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
        [paren{@attribute.to_sql},paren{@value.to_sql}].compact.join(" \nOR " )
      end
    end

    module Stateable
      ##
      # :attr_reader: statement
      def statement
        @statement
      end

      # Generate a new AndStatement and set statement to it.
      # Return self
      def and(state)
        safe_statement(state) do |st|
          @statement = Sower::Relation::AndStatement.new(@statement,st)
        end
      end
      alias_method :where, :and

      # Generate a new OrStatement and set statement to it.
      # Return self
      def or(state)
        safe_statement(state) do |st|
          @statement = Sower::Relation::OrStatement.new(@statement,st)
        end
      end

      # Just return a nil value when invoking #to_sql for Stateable objects.
      def to_sql
        nil
      end
      
      private
      def safe_statement(state,&block)
        if statement.nil?
          @statement = Sower::Relation::Statement.new(state.attribute, state.value)
        else
          @statement = yield(state)
        end
        self
      end
    end

  end
end
