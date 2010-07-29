module DbSower
  module Dumpers
    class Mysql

      attr_reader :config, :options, :command, :ident, :conditions, :dest
      def initialize(ident,args = {})
        @ident, @options = ident, args
        @conditions = @options.delete(:conditions)
        @dest = @options.delete(:to)
        @config = ident.to_hash
        @command = @config[:command] || '/usr/bin/mysqldump'
        @config.delete_if{|k,v| v.nil? || v.respond_to?(:empty?) && v.empty? || ![:database, :host, :user, :password, :socket, :port].include?(k)}
      end

      def execute
        system(command,*dump_options)
      end

      # keys available : table
      def generate_credential_options
        config.map do |k,v|
          ["--#{k}","#{v}"]
        end.sort
      end

      def generate_conditions
        return [] if conditions.nil? || conditions.empty?
        ["--where",%Q{"#{conditions}"}]
      end

      def generate_mysqldump_options
        a = options.map do |k,v|
          case v
          when nil
            ["--#{k}"]
          else
            ["--#{k}","#{v}"]
          end
        end
        a << ['--result-file',dest] unless dest.nil? || dest.empty?
        a.sort
      end

      def dump_options
        (generate_credential_options + generate_conditions + generate_mysqldump_options).map{|a| a.join(' ')}
      end

    end
  end
end
