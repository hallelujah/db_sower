module Sower
  module Relation
    module Value

      class Key
        def initialize(key)
          @key = key
        end

        def bind(val)
          Sower::Relation::Value::IDENTIFIERS[@key].sub('?',val)
        end
      end

      class Base
        attr_reader :value

        class_inheritable_reader :key

        def initialize(value)
          @value = value
        end

        def to_sql
          key.bind(value.to_sql)
        end

        def self.key=(k)
          write_inheritable_attribute(:key, Key.new(k))
        end
      end

      IDENTIFIERS = {
        :in => "IN (?)",
        :not_in => "NOT IN (?)",
        :eq => "= ?",
        :ne => "!= ?",
        :lt => "< ?",
        :gt => "> ?",
        :lte => "<= ?",
        :gte => ">= ?",
        :like => "LIKE ?"
      }

      IDENTIFIERS.each do |k,v|
       klass = self.const_set(k.to_s.classify, Class.new(Base))
       klass.key = k
      end

      extend self

      IDENTIFIERS.keys.each do |m|
        module_eval <<-DEF
          def #{m.to_s}(value)
            Sower::Relation::Value::#{m.to_s.classify}.new(value)
          end
        DEF
      end
    end
  end
end
