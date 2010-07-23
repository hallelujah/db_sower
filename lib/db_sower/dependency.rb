require 'db_sower/conditional'
module DbSower

  class Dependency
    attr_reader :name, :options
    include DbSower::Conditional

    def initialize(name,options={})
      @name = name.to_s.to_sym
      @options = options
      @conditions = []
    end

    def where(cond)
      @conditions << cond
      self
    end

    def eql?(other)
      Dependency === other && self.name.eql?(other.name) && self.options.eql?(other.options)
    end
    alias == eql?

    def hash
      [name,options].hash
    end
  end

  class Conditions
    include Conditional

    attr_reader :dependencies

    def initialize
      @dependencies = []
      @conditions = []
    end

    def with(table, options = {})
      dep = Dependency.new(table,options)
      @dependencies.find{|d| dep.name == d.name && dep.options == d.options } || @dependencies << dep && dep
    end
  end

end
