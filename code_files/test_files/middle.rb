require 'rubygems'
require "socket"
require 'rexml/document'
require 'open-uri'

require "crack"
require "json"
require "active_support"
require 'rack'
require 'rack/server'
require 'app'

include REXML


class HW  
     out = ""
    def call(env) 
     (1..4).each do |i|
        xmlDataFile = File.open("./demoparsing.xml", "w")
        xmlDataFile << open("http://172.16.17.18:8080/libreplan/ws/rest/resources/WORKER000"+"#{i}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
        xmlDataFile.close


         myXML  = Crack::XML.parse(File.read("./demoparsing.xml"))
         myJSON = myXML.to_json
         
         #puts File.read("demoparsing.xml")
         #puts myJSON
         leaves=0
         data = ActiveSupport::JSON.decode(myJSON)
         out += "<h1><font size='3' color='red'>" + "<i><u>Worker</u></i> : "  + data["worker"]["first_name"] + "<br/> </font></h1>" 
     end
        [200,{"Content-Type"=> "text/html"},StringIO.new(out) ]
    end  
end  
 run HW.new
