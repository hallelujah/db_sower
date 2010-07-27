require 'db_sower/conditional'
module DbSower
  class Edge
    attr_reader :from, :to

    include DbSower::Conditional

    def initialize(from,to)
      @conditions = []
      @from, @to = from, to
    end

    def head_columns
     cols = conditions.map(&:values).flatten.uniq
     cols.reject!{|k| ! k.is_a?(Symbol) }
     cols
    end

    def tail_columns
     cols = conditions.map(&:keys).flatten.uniq
     cols.reject!{|k| ! k.is_a?(Symbol) }
     cols
    end
  end
end
