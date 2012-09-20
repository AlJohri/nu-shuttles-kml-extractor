#!/usr/bin/ruby


=begin

Known Routes

http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046246a50cf04a21430 - Shop-N-Ride
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00045d8b8b9a7617aaead - Intercampus
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046247272e37f3a6365 - Chicago Express
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.000462463cb0fbdd7a5a7 - Ryan Field
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046245922d6398199dd - Evanston Loop
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046281a3d1ac54461a4 - Campus Loop
https://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.0004635ff91bc879913fc - Randolph/LaSalle Station AM
https://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046360187422e5e0953 - Randolph/LaSalle Station PM
https://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.0004635c56ef3691c7627 - Ogilvie/Union Station AM
https://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.0004635c68dd5df291d41 - Ogilvie/Union Station PM
http://maps.google.com/maps/ms?msa=0&msid=209440134627172181780.00046246de55f4f73f24f - Frostbite Express
http://maps.google.com/maps/ms?msa=0&msid=200725481515120343586.0004b645f2cbd1b31ad1f - Frostbite Sheridan


Known Users

https://maps.google.com/maps/user?uid=107438979254354659119&ptab=2 - doesn't work (interchangable with Lee in links)
https://maps.google.com/maps/user?uid=209440134627172181780&ptab=2 - Lee (owns all maps but one)
https://maps.google.com/maps/user?uid=200725481515120343586&ptab=2 - Jessica (owns one map - Frostbite Sheridan)
https://maps.google.com/maps/user?uid=213364722514591193464&ptab=2 - s-schapmann (edits maps, is collaborator, link is blank)

easy to parse route url from Lee and Jessica's maps but static values will keep it more controlled for now.
can manually notify when new route is created

http://i.imgur.com/XMj6b.png


gsub(/<\/?[^>]*>/, "")

=end

=begin

		//var s = document.createElement('div');
		//s.className = "timetable";
		//s.innerHTML = '<span id="closet" style="float: right; padding: 8px;">X</span>';
		//s.innerHTML += "<ul>" + md.featureData.infoWindowHtml.replace(/([0-9]+:[0-9]+[ap]?[*]?)(,|\s)?/g,"<li>$1</li>") + "</ul>"
		//document.body.appendChild(s);


<div style="font-family: Arial, sans-serif; font-size: small">
	<div style="font-weight: bold; font-size: medium; margin-bottom: 0em">
		Name
	</div>
<div>
<div dir="ltr">
</div> 


=end

require 'net/http'
require 'rexml/document'

$output

urlBase = 'http://maps.google.com/maps/ms?msa=0&msid='
uuidLee = '209440134627172181780' # Lee
uuidJess = '200725481515120343586' # Jessica
format = '&output=kml'

routes = 	[['209440134627172181780', '00046246a50cf04a21430'],  # Lee , Shop-N-Ride
			 ['209440134627172181780', '00045d8b8b9a7617aaead'],  # Lee , Intercampus
			 ['209440134627172181780', '00046247272e37f3a6365'],  # Lee , Chicago Express
			 ['209440134627172181780', '000462463cb0fbdd7a5a7'],  # Lee , Ryan Field
			 ['209440134627172181780', '00046245922d6398199dd'],  # Lee , Evanston Loop
			 ['209440134627172181780', '00046281a3d1ac54461a4'],  # Lee , Campus Loop
			 ['209440134627172181780', '0004635ff91bc879913fc'],  # Lee , Randolph/LaSalle Station AM
			 ['209440134627172181780', '00046360187422e5e0953'],  # Lee , Randolph/LaSalle Station PM
			 ['209440134627172181780', '0004635c56ef3691c7627'],  # Lee , Ogilvie/Union Station AM
			 ['209440134627172181780', '0004635c68dd5df291d41'],  # Lee , Ogilvie/Union Station PM
			 ['209440134627172181780', '00046246de55f4f73f24f'],  # Lee , Frostbite Express
			 ['200725481515120343586', '0004b645f2cbd1b31ad1f']]  # Jes , Frostbite Sheridan



for rt in routes

	url = urlBase + rt[0] + "." + rt[1] + format
	xml_data = Net::HTTP.get_response(URI.parse(url)).body
	doc = REXML::Document.new(xml_data)
	root = doc.root
	name = root.elements[1].elements['name'].text
	description = root.elements[1].elements['description'].text.gsub(/\n/," ")

	# Special Cases

	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text }

	# if name.include? "Shop-N-Ride"
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text }
	# elsif name.include? "Intercampus Shuttle"
	# 	#placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text }
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text}
	# elsif name.include? "Chicago Express"
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text }
	# elsif name.include? "Campus Loop Shuttle"
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text.scan(/(:[0-9]+)\s+(:[0-9]+)/).map { |i| i[0].to_s + " | " + i[1].to_s }.join(", ")}
	# elsif name.include? "Frostbite" # Frostbite Express and Sheridan
	# 	# Adjust for AM/PM and am/pm instead of a/p
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text.scan(/([0-9]+:[0-9]+\s+(AM|PM)?[*]?)(,|\s)?/i).map { |i| i[0].to_s }.join(", ")}
	# else
	# 	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text.scan(/([0-9]+:[0-9]+[ap]?[*]?)(,|\s)?/).map { |i| i[0].to_s }.join(", ")}
	# end


	puts "Name: " + name
	puts "Description: " + description
	puts "Placemarks: "
	puts placemarks
	puts ""
	puts ""

	url = nil
	xml_data = nil
	doc = nil
	root = nil
	name = nil
	description = nil
	placemarks = nil
end

=begin
class A
  def initialize(string, number)
    @string = string
    @number = number
  end
 
  def to_s
    "In A:\n   #{@string}, #{@number}\n"
  end
 
  def to_json(*a)
    {
      "json_class"   => self.class.name,
      "data"         => {"string" => @string, "number" => @number }
    }.to_json(*a)
  end
 
  def self.json_create(o)
    new(o["data"]["string"], o["data"]["number"])
  end
end

a = A.new("hello world", 5)
json_string = a.to_json
puts json_string
puts JSON.parse(json_string)

=end



#placemarks = REXML::XPath.match(root, "//Placemark[Point]").map {|x| x.elements['name'].text + ": " + x.elements['description'].text }



=begin

get '/' do
	"hello world"
end


	stops = Hash.new
	times = []
	placemarks = REXML::XPath.match(root, "//Placemark[Point]").map { 
		|x| x.elements['description'].text.scan(/([0-9]+:[0-9]+[ap]?[*]?)(,|\s)?/).map { 
			|i| times.push(i[0].to_s) 
		}
		stops[x.elements['name'].text] = times
		puts stops
	}
=end
