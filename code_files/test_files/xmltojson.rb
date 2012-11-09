require "crack"
require "json"
require 'rubygems'
require "active_support"

myXML  = Crack::XML.parse(File.read("./demoparsing.xml"))
myJSON = myXML.to_json

#puts File.read("demoparsing.xml")
#puts myJSON

leaves=0
data = ActiveSupport::JSON.decode(myJSON)
puts "User : "  + data["worker"]["first_name"]

data["worker"]["calendar"]["calendar_exception_list"]["calendar_exception"].each { |entry|
  if entry["calendar_exception_type_code"] == "CALENDAR_EXCEPTION_TYPE0002"
  	 puts "Type:'Leave' at Date:" + entry["date"]
  	 leaves+=1
  end
  #puts data["worker"]["calendar"]["calendar_exception_list"]["calendar_exception"]
}


joining_date = Time.local(2012, "aug", 01, 12,0,0)

current_date = Time.now

number_of_months_since_joining = (current_date.year-joining_date.year) + (current_date.month-joining_date.month)
no_of_holidays = 1.25*number_of_months_since_joining
puts "Number of holidays earned over the period of time: #{no_of_holidays}" 
puts "Number of leaves taken : #{leaves}"
puts "so remaining holidays are : #{no_of_holidays-leaves}"