$:.unshift(File.expand_path('../../lib',__FILE__))
require 'rubygems'
require 'active_record'
require 'db_sower'

seed = DbSower::Seed.new 
file = File.expand_path('../aimfar.yml',__FILE__)
ActiveRecord::Base.configurations = YAML.load_file(file).with_indifferent_access

seed.graft(:identifier => :aimfar_prod) do 
  clients.where(:id => 4)
  users.with(:clients).where(:client_id => :id)
  achats.where(:status => [-1,1]).with(:clients).where(:client_id => :id)
  campagnes.with(:achats).where(:id => :campagne_id)
  creations.with(:achats).where(:achat_id => :id)
  ciblages
end
ident = DbSower::DumpBackend::Identifier.new(ActiveRecord::Base.configurations[:aimfar_prod])

backend = DbSower::DumpBackend.new(seed,file)

seed.tsort.each do |node|
  identifier = node.options[:identifier]
  database = backend.config[identifier][:database]
  dumper = DbSower::Dumpers::Mysql.new(ident, :table => node.table_name, :conditions => backend.adapter(node).formatted_conditions(backend), :to => "#{database}.sql", :append => true)
#  puts dumper.command_line.join(' ')
  puts "Dumping #{database}.#{node.table_name}"
  dumper.execute
end

