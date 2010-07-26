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

    def node_alias
      @node_alias ||= "#@name"
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

    def with(node_alias, options = {})
      node = DbSower::Node.new(@seed,node_alias,options)
      node = @seed.node(node)
      @seed.edge(self,node)
    end

    def inspect
      node_alias
    end

    def to_s
      node_alias
    end

    def table_name
      if options[:table]
        if options[:database]
          [options[:database],options[:table]].join('.')
        else
          options[:table].to_s
        end
      else
        node_alias
      end
    end

  end
end

