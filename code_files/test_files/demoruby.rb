require 'rexml/document'
require 'open-uri'

include REXML



#opening a file..............................................

(1..4).each do |i|
	    xmlDataFile = File.open("./demoparsing.xml", "w")
        xmlDataFile << open("http://172.16.17.18:8080/libreplan/ws/rest/resources/WORKER000"+"#{i}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
        xmlDataFile.close

        
        xmlfile = File.open("./demoparsing.xml","r")
        xmldoc = Document.new(xmlfile)
        
        
        
        #XPath.each(xmldoc, "//movie"){ |m| puts m.attributes["title"]}
        #
        #XPath.each(xmldoc, "//movie/type"){ |m| puts m.text}
        
        #Get an array of all of the movie formats.
        #names = XPath.match(xmldoc, "//format").map {|x| x.text }
        #p names
        worker_names = XPath.match(xmldoc, "//worker").map{ |worker| worker.attributes["first-name"] }
        p worker_names
        
        
        XPath.each(xmldoc, "//calendar-exception"){ |e|
        	if e.attributes["calendar-exception-type-code"] == "CALENDAR_EXCEPTION_TYPE0002"
        	  puts "Type:'Leave' at Date:" + e.attributes["date"]	
        	end
        }



end
#..............................................................