require 'helper'

class TestDbSowerDependency < Test::Unit::TestCase

  def test_name
    dep = DbSower::Dependency.new(:name1)
    d = DbSower::Dependency.new('name2')
    assert_equal :name1, dep.name
    assert_equal :name2, d.name
  end
  
  def test_options
    d = DbSower::Dependency.new(:toto)
    dep = DbSower::Dependency.new(:titi, {:database => :base1})
    assert_equal Hash.new, d.options
    assert_equal({:database => :base1}, dep.options)
  end
  
  def test_equality
    dep = DbSower::Dependency.new(:toto)
    d = DbSower::Dependency.new(:toto)
    assert dep.eql?(d)
    assert d.eql?(dep)
    assert dep == d
    assert d == dep

    dep = DbSower::Dependency.new(:toto, :database => :base1)
    d = DbSower::Dependency.new(:toto, :database => :base2)
    assert ! dep.eql?(d)
    assert ! d.eql?(dep)
    assert dep != d
    assert d != dep

    dep = DbSower::Dependency.new(:tete, :database => :base1)
    d = DbSower::Dependency.new(:toto, :database => :base2)
    assert ! dep.eql?(d)
    assert ! d.eql?(dep)
    assert dep != d
    assert d != dep

    dep = DbSower::Dependency.new(:tete)
    d = DbSower::Dependency.new(:toto)
    assert ! dep.eql?(d)
    assert ! d.eql?(dep)
    assert dep != d
    assert d != dep

  end

  def test_where
    d = DbSower::Dependency.new(:table)
    assert_equal d,  d.where(:tata => [1,2,3,5])
    assert_equal([{:tata => [1,2,3,5]}],  d.conditions)
  end
end
