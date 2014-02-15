require "json"

Dir.glob('data/*.json').sort.each do |file|
  puts file
  data = JSON.parse(File.read(file))
  File.open(file, 'w') { |file| file.write(JSON.pretty_generate(data)) } 
end
