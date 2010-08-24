require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sower"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "hery@rails-royce.org"
    gem.homepage = "http://github.com/hallelujah/sower"
    gem.authors = ["hallelujah"]
    gem.add_development_dependency "shoulda", ">= 0"
    gem.add_development_dependency "test-unit", ">= 2.1.0"
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
    test.rcov_opts << "--exclude /gems/"
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sower #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

def update_rails
  return if @rails_updated
  @git_branch = "3-0-stable"
  @dir = File.join(ENV['HOME'],'Software','rails')
  @git_dir = File.join(@dir,'.git')
  @branch = `git --work-tree=#{@dir} --git-dir=#{@git_dir} name-rev --name-only HEAD`.strip
  unless @branch == @git_branch
    system("git --work-tree=#{@dir} --git-dir=#{@git_dir} co #{@git_branch}") or puts "Can not check out #{@git_branch} stable, is #{@branch}" or exit(1)
  else
    puts "already in branch #{@git_branch}"
  end
  `cd #{@dir} && git --git-dir=#{git_dir} --work-tree=#{dir} pull`
  @rails_updated = true
end

namespace :vendor do
  desc "update all vendored libraries"
  task :update => ["vendor:update:activerecord","vendor:update:activesupport","vendor:update:activemodel","vendor:update:arel","vendor:update:builder","vendor:update:tzinfo","vendor:update:i18n"]

  namespace :update do
    %w{activerecord activesupport activemodel}.each do |lib|
      desc "Update vendor/#{lib}"
      task lib.to_sym do
        update_rails
        dest = File.expand_path("../lib/vendor/#{lib}",__FILE__)
        src = File.expand_path(lib,@dir)
        FileUtils.rm_rf(dest)
        FileUtils.cp_r(src,dest)
      end
    end

    %w{arel builder tzinfo i18n}.each do |lib|
      desc "Update vendor/#{lib}"
      task lib.to_sym do
        dest = File.expand_path("../lib/vendor",__FILE__)
        version = `gem list #{lib}`.strip
        m = version.match(/.*\(([^,]*).*\).*/)
        if m
          version = m[1]
        else
          raise "must install #{lib} : please run gem install #{lib}"
        end
        puts version
        FileUtils.rm_rf(File.join(dest,lib))
        Dir.chdir(dest) do
          system("gem unpack #{lib}")
          Dir.chdir(dest) do
            FileUtils.mv("#{lib}-#{version}",lib)
          end
        end
      end
    end

  end
end
