require 'helper'

class TestDbSower < Test::Unit::TestCase

  def test_draw_dependency
    seed = DbSower::Seed.new
    seed.supply(:file => File.expand_path('../config/seeds.yml', __FILE__))

    seed.graft do
      creations.with(:achats).where(:achat_id => :id)
      masques.with(:creations).where(:id => :masque_id)
    end

    spacer = " " * 10
    seed.tsort_each_node do |dep|
      puts '-' * 40
      puts "Querying [#{dep.name}] with options #{dep.options.inspect}"
      puts
      puts dep.sql
      seed.tsort_each_child(dep) do |child|
        puts spacer+('-' * 30)
        puts spacer + "Querying [#{child.name}] with options #{child.options.inspect}"
        puts
        puts spacer + child.sql

      end

    end
    # 3 tables are declared :creations, :achats and masques
    assert_equal 3, seed.tables.size
  end
end
