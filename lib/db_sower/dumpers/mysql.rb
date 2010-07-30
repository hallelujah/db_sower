module DbSower
  module Dumpers
    class Mysql

      attr_reader :config, :options, :command, :ident, :dest
      attr_accessor :conditions
      def initialize(ident,args = {})
        @ident, @options = ident.clone, args.clone
        @conditions = @options.delete(:conditions)
        @dest = @options.delete(:to)
        @config = ident.to_hash.clone
        @command = @config[:command] || '/usr/bin/mysqldump'
        @database = @config.delete(:database)
        @table = @options.delete(:table).to_s
        @config.delete_if{|k,v| v.nil? || v.respond_to?(:empty?) && v.empty? || ![ :host, :user, :password, :socket, :port].include?(k)}
      end

      def execute
        system(*command_line)
      end

      def command_line
        [command,*dump_options]
      end

      # keys available : table
      def generate_credential_options
        a = config.map do |k,v|
          ["--#{k}=#{v}"]
        end.sort
        a += [[@database],[@table]]
        a
      end

      def generate_conditions
        return [] if conditions.nil? || conditions.empty?
        [["--where",%Q{'#{conditions}'}]]
      end

      def generate_mysqldump_options
        a = options.map do |k,v|
          case v
          when true
            ["--#{k}"]
          else
            ["--#{k}","#{v}"]
          end
        end
        a << ['--result-file',dest] unless dest.nil? || dest.empty?
        a.sort
      end

      def dump_options
        (generate_credential_options + generate_mysqldump_options + generate_conditions ).map{|a| a.join(' ')}
      end

    end
  end
end
