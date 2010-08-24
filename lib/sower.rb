# Use vendored libraries
$:.unshift(File.expand_path('../vendor/activesupport/lib',__FILE__))
%w{activerecord activesupport activemodel arel builder i18n tzinfo}.each do |lib|
  path = File.expand_path("../vendor/#{lib}/lib",__FILE__)
  $:.unshift(path)
end

class Object
  def to_sql
    "'#{to_s}'"
  end
  def to_dot
    nil
  end
end
class NilClass
  def to_sql
    nil
  end
end
class Array
  def to_sql
    map(&:to_sql).join(',')
  end
end

require 'active_support/all'
require 'active_support/version'
puts ActiveSupport::VERSION::STRING


require 'sower/relation'
require 'sower/condition'
require 'sower/node'
require 'sower/edge'
require 'sower/graph'
require 'sower/design'
module Sower # :nodoc:
end
