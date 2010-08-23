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
        [@attribute.to_sql,@value.to_sql].join(' ')
      end
    end

    class AndStatement < Statement
      def to_sql
        "(#{@attribute.to_sql}) AND (#{@value.to_sql})"
      end
    end

    class OrStatement < Statement
      def to_sql
        "(#{@attribute.to_sql}) OR (#{@value.to_sql})"
      end
    end

  end
end
