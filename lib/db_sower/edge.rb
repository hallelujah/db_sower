require 'db_sower/conditional'
module DbSower
  class Edge
    attr_reader :from, :to

    include DbSower::Conditional

    def initialize(from,to)
      @conditions = []
      @from, @to = from, to
    end
  end
end
