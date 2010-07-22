require 'tsort'

module DbSower
  class Seed

    include TSort

    def tsort_each_node(&block)
      @dependencies.each_key(&block)
    end

    def tsort_each_child(node, &block)
      @dependencies.fetch(node).dependencies.each(&block) if @dependencies.has_key?(node)
    end

    attr_reader :dependencies

    def tables
      tsort.map{|dep| Table.new(dep.name,dep.options)}
    end

    def initialize
      @dependencies = Hash.new{|h,k| h[k] = Conditions.new}
    end

    def graft(&block)
      Proxy.new(self,&block)
    end

    def supply(options={})
    end

  end


  class Proxy

    def initialize(seed,&block)
      @seed = seed
      instance_exec(&block) if block_given?
    end

    def method_missing(table_name, *args)
      dep = Dependency.new(table_name,*args)
      @seed.dependencies[dep]
    end

  end

  class Table
    def initialize(name,options ={})
      @name = name
      @options = options
    end
  end
end
