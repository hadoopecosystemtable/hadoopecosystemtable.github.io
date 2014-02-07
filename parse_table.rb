require "nokogiri"
require "json"
require "pp"

page = Nokogiri::HTML(open("index.html"))

table = page.css("table")[0]

# categories = table.css("th").map do |th|
# 	th.children.first
# end

# puts "\"#{categories.join("\", \n\"")}\""

category = ""

table.css("tr").each do |tr|
  if tr.children.first.name == "th"
    category = tr.children.first.children.to_s
  else
    data = {}
    data["name"] = tr.children[0].children.first.to_s
    data["description"] = tr.children[2].children.first.to_s
    data["abstract"] = ""
    data["category"] = category
    data["tags"] = []
    filename = "#{data["name"].downcase.gsub(/[^a-z0-9]/, "_")}.json"
    if tr.children[4].children.to_s == "TODO"
      data["links"] = []
    else
      data["links"] = []
      tr.children[4].children.each do |a|
        next unless a.is_a? Nokogiri::XML::Element and a.name == "a"
        data["links"] << {"text" => a.children.to_s.gsub(/^[0-9]+\. /, ""), "url" => a.attributes["href"].value.to_s}
      end
    end
    File.open("data/#{filename}", 'w') { |file| file.write(JSON.generate(data)) } 
  end
end
