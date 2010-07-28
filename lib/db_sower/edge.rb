require 'db_sower/conditional'
module DbSower
  class Edge
    attr_reader :tail, :head

    include DbSower::Conditional

    def initialize(tail,head)
      @conditions = []
      @tail, @head = tail, head
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

    def tail_head_columns_mapping
      h = conditions.inject({}) do |memo,c|
        memo.merge(c.conditions)
      end
      h.delete_if{ |k,v| ! (Symbol === k && Symbol === v)}
      h
    end

  end
end
