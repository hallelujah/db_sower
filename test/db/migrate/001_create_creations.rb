class CreateCreations < ActiveRecord::Migration
  def self.up
    change_config(:db1) do
      create_table :creations do |t|
        t.string :label, :null => false, :default => ''
        t.integer :masque_id, :null => true, :default => nil
      end
    end
  end
end
