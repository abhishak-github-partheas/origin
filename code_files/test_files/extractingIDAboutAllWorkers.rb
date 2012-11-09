require 'open-uri'
require "crack"
require "json"
require 'rubygems'
require "active_support"


file = File.open("all_resources.xml", 'w')
file<<open("http://172.16.17.18:8080/libreplan/ws/rest/resources", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
file.close


WORKER_CODE_LIST = [], i=0
myXML  = Crack::XML.parse(File.read("./all_resources.xml"))
myJSON = myXML.to_json

data = ActiveSupport::JSON.decode(myJSON)
#puts data

data["resource_list"]["worker"].each{ |worker|
  WORKER_CODE_LIST[i] = worker["code"]
  i+=1
}

# puts WORKER_CODE_LIST.inspect
# puts "length = #{WORKER_CODE_LIST.length}"