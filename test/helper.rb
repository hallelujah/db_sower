require 'rubygems'
gem 'test-unit', '>= 2.1'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sower'

class Test::Unit::TestCase
end
