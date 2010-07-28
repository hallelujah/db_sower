require 'rubygems'
gem 'test-unit', '>= 2.1.0'
require 'test/unit'

$test_root = File.dirname(__FILE__)
$LOAD_PATH.unshift($test_root)
$LOAD_PATH.unshift(File.join($test_root,"model"))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'db_helper'
require 'db_sower'

Dir.glob(File.expand_path('../model/**/*.rb',__FILE__)).each do |lib|
  f = File.basename(lib)
  require(f)
end



class Test::Unit::TestCase
  include ActiveRecord::TestFixtures
  self.fixture_path = File.expand_path("../db/fixtures",__FILE__)
  self.use_instantiated_fixtures = false
  self.use_transactional_fixtures = false
  set_fixture_class :categories => 'Categorie'
end


