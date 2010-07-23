require 'pathname'
base_path = Pathname(File.dirname(__FILE__))
$:.unshift(base_path)
Dir.chdir(base_path) do
  Dir['**/*.rb'].each do |lib|
    file = Pathname.new(File.join(base_path, lib))
    require file.relative_path_from base_path
  end
end
