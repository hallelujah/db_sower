module Sower
  module Relation
    class Statement
      def initialize(attribute,value)
        @attribute = attribute
        @value = value
      end

      def where(statement)
        AndStatement.new(self, statement)
      end
      alias and where

      def or(statement)
        OrStatement.new(self,statement)
      end

      def to_sql
        [@attribute.to_sql,@value.to_sql].compact.join(' ')
      end

      protected
      def paren
        res = yield.to_s.strip
        res.empty? ? nil : "(#{res})"
      end

    end

    class AndStatement < Statement
      def to_sql
        [paren{@attribute.to_sql},paren{@value.to_sql}].compact.join(" \nAND " )
      end
    end

    class OrStatement < Statement
      def to_sql
        "(#{@attribute.to_sql}) \nOR (#{@value.to_sql})"
      end
    end

    module Stateable
      def statements
        @statements
      end

      def where(statement)
        if statements.nil?
          @statements = Sower::Relation::Statement.new(@statements,statement)
        else
          @statements = Sower::Relation::AndStatement.new(@statements,statement)
        end
        self
      end

      def and(statement)
        @statements = Sower::Relation::AndStatement.new(@statements,statement)
        self
      end

      def or(statement)
        @statements = Sower::Relation::OrStatement.new(@statements,statement)
        self
      end

      def to_sql
        nil
      end
    end

  end
end
