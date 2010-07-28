require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "db_sower"
    gem.summary = %Q{A database sower with a nice DSL}
    gem.description = %Q{On large database project, when you have too many data it can be useful to fetch a small part of your data. Describe your database with a nice dsl, filters some data and fetch them}
    gem.email = "hery@rails-royce.org"
    gem.homepage = "http://github.com/hallelujah/db_sower"
    gem.authors = ["hallelujah"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

namespace :test do
  namespace :db do
    
    desc "prepare databases for tests"
    task :prepare do
      $:.unshift(File.expand_path('test',File.dirname(__FILE__)))
      require 'migrator'
      Migrator.migrate
    end
  end
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "db_sower #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
