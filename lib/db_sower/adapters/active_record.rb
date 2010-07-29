require 'active_record'
module DbSower
  module Adapters
    class ActiveRecord

      attr_reader :node, :ident, :config, :model, :dumper
      def initialize(node,ident, config)
        @dumper = 'mysqldump'
        @node = node
        @ident = ident
        ::ActiveRecord::Base.configurations = (::ActiveRecord::Base.configurations || {}).merge(config)
        ::ActiveRecord::Base.establish_connection @ident
        @model = Class.new(::ActiveRecord::Base)
        @model.table_name = @node.table_name
      end

      # TODO must be more logically divided
      # SEE DbSower::DumpBackend#values_at
      def formatted_conditions(backend)
        a = nil
        node.each_edge do |head,edge|
          a = merge_conditions(a,backend.values_at(edge,:head))
        end
        a
      end

      def dump
        node.table_name
        node.columns.each do |col|
          # TODO : Must use cache
          File.open(node.file_for_column(col),'w+') do |f|
            f.puts({col => select_values(col)}.to_yaml)
          end
        end
      end

      def select_values(col)
        sql = construct_finder_sql(
          :select => col.to_s,
          :conditions => conditions(node.conditions)
        )
        connection.select_values(sql).uniq
      end

      def conditions(array_conditions)
        array_conditions.inject(nil)  do |memo,c|
          merge_conditions(memo,c.conditions)
        end
      end

      def method_missing(meth,*args)
        model.__send__(meth,*args)
      end

    end
  end
end
