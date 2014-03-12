require "nokogiri"
require "json"
require "pp"

page = Nokogiri::HTML(open("blog.html"))

page.css("li").each do |li|
  name, abstract = li.content.split(":")
  puts name
  a = li.css("a")[0]
  filename = "#{name.downcase.gsub(/[^a-z0-9]/, "_")}.json"
  if File.exists? "data/#{filename}"
    # unless abstract.nil?
    #   data = JSON.parse(File.read("data/#{filename}"))
    #   data["abstract"] = abstract.to_s.strip if data["abstract"].empty?
    #   data["description"] = abstract.to_s.strip if data["description"].empty? 
    #   File.open("data/#{filename}", 'w') { |file| file.write(JSON.generate(data)) } 
    # end 
    unless a.nil?
      puts name
      data = JSON.parse(File.read("data/#{filename}"))
      url = a.attributes["href"].value
      text = name
      data["links"] << {"text" => text, "url" => url} if data["links"].empty?
      File.open("data/#{filename}", 'w') { |file| file.write(JSON.generate(data)) }
    end
  
  # else
  #   data = {}
  #   data["name"] = name
  #   data["description"] = abstract.strip
  #   data["abstract"] = abstract.strip
  #   data["category"] = "Uncategorized"
  #   data["tags"] = []
  #   data["links"] = []
  #   File.open("data/#{filename}", 'w') { |file| file.write(JSON.generate(data)) } 
  end
end
