require 'helper'
class TestAll < Test::Unit::TestCase
  def setup
    @graph = Sower::Graph.new
    feed_graph
    @graph.draw do
      achats.depends_on(campagnes).where(achats[:campagne_id].eq(campagnes[:id]))
    end
    puts @graph.tsort
  end

  context "achats-campagbes" do
    should "have statement" do
      assert sql = @graph.edges['achats']['campagnes'].statement
      puts sql.to_sql
    end
  end

  def feed_graph
    config = YAML.load_file(File.expand_path('../config.yml',__FILE__))
    config.each do |c|
      node = Sower::Node.new(c)
      @graph.add_node(node)
    end
  end
end
