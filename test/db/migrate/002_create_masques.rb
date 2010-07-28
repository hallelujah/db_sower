class CreateMasques < ActiveRecord::Migration
  def self.up
    change_config(:db1) do
      create_table :masques do |t|
        t.string :label, :null => false, :default => ''
        t.text :body
      end
    end
  end
end
