require 'rexml/document'
require 'open-uri'

include REXML


emp_resorce_info = ""
     # file = File.open("all_resources.xml", 'w')
     emp_resorce_info<<open("http://172.16.17.18:8080/libreplan/ws/rest/resources", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
     xml_doc_resorce = Document.new(emp_resorce_info)
     empl_code = XPath.match(xmldoc, "//worker").map{ |worker| worker.attributes["code"] }

     # file.close
     puts emp_resorce_info   

     puts empl_code      
    

#opening a file..............................................
# xmlDataFile = ""
# (1..4).each do |i|
# 	 xmlDataFile << open("http://172.16.17.18:8080/libreplan/ws/rest/resources/WORKER000"+"#{i}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
#         xmldoc = Document.new(xmlDataFile)
#         worker_names = XPath.match(xmldoc, "//worker").map{ |worker| worker.attributes["first-name"] }
#         p worker_names
        
        
#         XPath.each(xmldoc, "//calendar-exception"){ |e|
#           if e.attributes["calendar-exception-type-code"] == "CALENDAR_EXCEPTION_TYPE0002"
#             puts "Type:'Leave' at Date:" + e.attributes["date"] 
#           end
#         }    
        



# end
#..............................................................