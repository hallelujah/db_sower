module Sower # :nodoc:
  module Inspectable # :nodoc:
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def inspectable(*args)
        define_method(:to_s) do
          "#<#{self.class.to_s} #{args.map{|k| "#{k.to_s}: #{instance_variable_get('@' + k.to_s).inspect}" }.join(', ')}>"
        end
        alias_method :inspect, :to_s
      end
    end
  end
end
