require "socket"
require 'rexml/document'
require 'open-uri'

require "crack"
require "json"
require 'rubygems'
require "active_support"

include REXML



webserver = TCPServer.new('localhost', 2003)
#base_dir = Dir.new(".")
while (session = webserver.accept)
    session.print("HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n")
    session.print("<!Doctype html> <html> <head> <title> Holidays Info </title>
     <style> 
    .ex{ width:570px; 
    	 padding:10px;
    	 border:5px solid blue; 
    	 margin:0px;
         -webkit-border-radius: 10px;
         -moz-border-radius: 10px;
         border-radius: 10px;
        }
    
     </style> </head>")

    #........................................................................................... 
     file = ""
     # file = File.open("all_resources.xml", 'w')
     file<<open("http://172.16.17.18:8080/libreplan/ws/rest/resources", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
     # file.close
              
     #myXML  = Crack::XML.parse(File.read("./all_resources.xml"))
     myXML  = Crack::XML.parse(file)
     myJSON = myXML.to_json
     
     data = ActiveSupport::JSON.decode(myJSON)
     #puts data

     WORKER_CODE_LIST = [], i=0
     data["resource_list"]["worker"].each{ |worker|
       WORKER_CODE_LIST[i] = worker["code"]
       i+=1
     }
 
     #puts WORKER_CODE_LIST.inspect
    #...........................................................................................

    (0..(WORKER_CODE_LIST.length-1)).each do |i|
      # xmlDataFile = File.open("./demoparsing.xml", "w")
        xmlDataFile = ""
        xmlDataFile << open("http://172.16.17.18:8080/libreplan/ws/rest/resources/"+"#{WORKER_CODE_LIST[i]}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
        #xmlDataFile.close


         #myXML  = Crack::XML.parse(File.read("./demoparsing.xml"))
         myXML  = Crack::XML.parse(xmlDataFile)
         myJSON = myXML.to_json
         
         #puts File.read("demoparsing.xml")
         #puts myJSON
         leaves=0
         data = ActiveSupport::JSON.decode(myJSON)
         session.print("<section class='ex'>")
         session.print ("<h1><font size='3' color='red'>" + "<i><u>Worker</u></i> : "  + data["worker"]["first_name"] + "<br/> </font></h1>")
         
         data["worker"]["calendar"]["calendar_exception_list"]["calendar_exception"].each { |entry|
            if entry["calendar_exception_type_code"] <=> "CALENDAR_EXCEPTION_TYPE0002"
            	 session.print "Type:'Leave' at Date:" + entry["date"] + "<br/>"
            	 leaves+=1
            end
         }
                  
         joining_date = Time.local(2012, "aug", 01, 12,0,0)
         
         current_date = Time.now
         
         number_of_months_since_joining = (current_date.year - joining_date.year)*12 + (current_date.month-joining_date.month)
         no_of_holidays = 1.25 * number_of_months_since_joining
         session.print  "Number of holidays earned over the period of time: #{no_of_holidays}" + "<br/>"
        session.print "Number of leaves taken : #{leaves}" + "<br/>"
        session.print "so remaining holidays are : #{no_of_holidays - leaves}" + "<br/><br/>"
        
        session.print("</section><hr/>") 
    end
  session.close
end