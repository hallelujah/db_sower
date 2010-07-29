require 'active_support/core_ext/hash/indifferent_access'
class Hash
  include ActiveSupport::CoreExtensions::Hash::IndifferentAccess
end
class String
  unless method_defined?(:camelize)
    def camelize(first_letter_in_uppercase = true)
      if first_letter_in_uppercase
        self.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      else
        self.first.downcase + camelize(self)[1..-1]
      end
    end
  end
end
module DbSower
  class DumpBackend
    attr_reader :seed, :config
    def initialize(seed, config_file)
      @seed = seed
      @config = Config.parse(config_file)
    end

    def credentials(n)
      ident = identifier(n)
      Identifier.new(config[ident])
    end

    def arguments(n)
      a = [n.table_name]
      a << n.conditions unless n.conditions.empty?
      a
    end

    def identifier(n)
      node = seed.node(n)
      node.options[:identifier]
    end

    def dump(n)
      a = adapter(n)
      a.dump
    end

    def values_at(edge, tail_or_head)
      edge = seed.edge(edge.tail,edge.head)
      head = edge.head
      tail = edge.tail
      adapter = adapter(head)

      case tail_or_head
      when :head
        edge.head_columns.inject({}) do |memo,col|
          memo.merge({col => adapter.select_values(col)})
        end
      when :tail
        maps = edge.tail_head_columns_mapping
        edge.tail_columns.inject({}) do |memo,col|
          memo.merge({col => adapter.select_values(maps[col])})
        end
      else
        raise ArgumentError, "second argument must be :head or :tail"
      end
    end

    def adapter(n)
      ident = identifier(n)
      adapter = config[ident][:orm].to_s.camelize
      adapter = DbSower::Adapters.const_get(adapter)
      adapter.new(n,ident,config)
    end

    class Identifier
      def initialize(h)
        @database = h[:database]
        @socket = h[:socket]
        @user = h[:username]
        @password = h[:password]
        @host = h[:host]
        @port = h[:port]
      end

      def ==(other)
        case other
        when Hash, Identifier
          other == to_hash
        else
          super(other)
        end
      end

      def hash
        to_hash.hash
      end

      def eql?(other)
        self == other
      end

      def to_hash
        {:database => @database, :user => @user, :password => @password, :socket => @socket, :port => @port, :host => @host}
      end
    end

    module Config
      extend self
      def parse(file)
        YAML.load_file(file).with_indifferent_access
      end
    end
  end
end