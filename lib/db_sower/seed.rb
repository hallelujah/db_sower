require 'tsort'
module DbSower

  class Seed

    include TSort

    attr_reader :nodes, :edges

    def tsort_each_node(&block)
      nodes.values.each(&block)
    end

    def tsort_each_child(node, &block)
      @edges[node].each_key(&block)
    end

    def initialize
      @nodes = Hash.new
      @edges = Hash.new{ |h,k| h[k] = Hash.new}
    end

    def edges_size
      edges.values.map(&:keys).flatten.size
    end

    def edge(from,to)
      @edges[from][to] ||= DbSower::Edge.new(from,to)
    end

    def node(n)
      @nodes[n.node_alias] ||= n 
    end

    def graft(options = {}, &block)
      Proxy.new(self,options,&block)
      nil
    end

  end

  class Proxy
    def initialize(seed,options={},&block)
      @seed = seed
      @options = options
      instance_exec(&block)
    end

    def method_missing(node_alias,*args)
      options = (args.first || {}).merge(@options)
      node = DbSower::Node.new(@seed, node_alias,options)
      @seed.node(node)
    end
  end

end
