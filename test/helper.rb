require 'rubygems'
gem 'test-unit', '>= 2.1.0'
require 'test/unit'

$test_root = File.dirname(__FILE__)
$LOAD_PATH.unshift($test_root)
$LOAD_PATH.unshift(File.join($test_root,"model"))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'db_helper'
require 'db_sower'
