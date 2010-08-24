#%w{activerecord activesupport activemodel arel builder i18n tzinfo}.each do |lib|
#  path = File.expand_path("../vendor/#{lib}/lib",__FILE__)
#  $:.unshift(path)
#end
#require 'rubygems'
#gem 'activesupport', ">= 3.0.0.beta"
#gem 'activemodel', ">= 3.0.0.beta"
#gem 'activerecord', ">= 3.0.0.beta"
#require 'active_support/all'
#require 'active_record'
#require 'arel'
#ActiveRecord::Base.establish_connection({:adapter => 'mysql', :socket => '/tmp/webo-mysql-stat.sock', :database => 'aimfar_prod'})
#Arel::Table.engine = Arel::Sql::Engine.new(ActiveRecord::Base)
#users = Arel::Table.new(:users)
#puts Arel::Project.new(users,users[:id]).to_sql

require 'active_support/core_ext'
require 'sower/relation'
require 'sower/condition'
require 'sower/node'
require 'sower/edge'
require 'sower/graph'
require 'sower/design'
module Sower # :nodoc:
end
