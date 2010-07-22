require 'helper'

class TestDbSowerDependency < Test::Unit::TestCase

  def test_equality
    dep = DbSower::Dependency.new(:toto)
    d = DbSower::Dependency.new(:toto)
    assert dep.eql?(d)
    assert d.eql?(dep)

    assert dep == d
    assert d == dep
  end
end
