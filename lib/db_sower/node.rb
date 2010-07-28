require 'db_sower/conditional'
module DbSower
  class Node
    attr_reader :options, :seed, :name

    include Conditional

    def initialize(seed, name,options = {})
      @conditions = []
      @seed = seed
      @name = name.to_sym 
      @options = options.clone
    end

    def columns
      cols = []
      each_reverse_edge do |tail,edge| 
        cols.concat(edge.head_columns)
      end
      each_edge do |head,edge| 
        cols.concat(edge.tail_columns)
      end
      cols.uniq
    end

    def node_alias
      @node_alias ||= "#@name"
    end

    def with(node_alias, options = {})
      node = DbSower::Node.new(@seed,node_alias,options)
      n = @seed.node(node)
      @seed.edge(self,n)
    end

    def each_edge(&block)
      @seed.edges[self].each(&block)
    end

    def each_reverse_edge(&block)
      @seed.reverse_edges[self].each(&block)
    end

    def file_for_column(col)
      self.node_alias + '-' + col.to_s + '.yml'
    end

    def table_name
      (options[:table] || name).to_s
    end

    def inspect
      node_alias
    end

    def to_s
      node_alias
    end

    def ==(other)
      node_alias == other.node_alias
    end

    def eql?(other)
      node_alias.eql?(other.node_alias)
    end

    def hash
      node_alias.hash
    end

  end
end

