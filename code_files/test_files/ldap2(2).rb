#require 'rubygems'
require 'net/ldap'
require "socket"
require 'rexml/document'
require 'open-uri'
require "crack"
require "json"
require "active_support"
require 'yaml'
require 'json'

include REXML

load 'LDAPmodule.rb'
include LoadLDAP



LoadLDAP.initializeLDAP
#...................Data fetch from LDAP........................
# thing = YAML.load_file('ldap_conf.yml')
# #puts thing.inspect

# ldap = Net::LDAP.new :host => thing["host"],
#      :port => thing["port"],
#      :auth => {
#            :method =>  thing["method"],
#            :username => thing["username"],
#            :password => thing["password"]
#      }
     
is_authorized = ldap.bind # returns true if auth works, false otherwise (or throws error if it can't connect to the server)
if ldap.bind
  puts "authentication succeeded"
else
  puts "authentication failed"
end

filter = Net::LDAP::Filter.eq("uid", "*")
treebase = "dc=partheas,dc=net"
attrs=['displayname', 'employeestartdate','employeeenddate']

ldap_data=[]

ldap.search(:base => treebase,:attributes => attrs, :filter => filter) do |entry|
  entry.each do |attribute, values|
  if attribute.to_s == "displayname" 
   ldap_data << values.join("")
  end 
  if attribute.to_s == "employeestartdate"   
    ldap_data << values.join("")
   end 
  if attribute.to_s == "employeeenddate"   
   ldap_data << values.join("")
  end
 end
  if ldap_data.length % 3 != 0
    ldap_data << ''
  end 
end
p "--------ldap_data"
p ldap_data
#.............................................................................





#...................Extracting data from libreplan..............................
webserver = TCPServer.new('localhost', 2005)
  
  employees_info={}
  WORKER_CODE_LIST = []

while (session = webserver.accept)
     emp_resorce_info = ""

     emp_resorce_info<<open("http://172.16.17.18:8080/libreplan/ws/rest/resources", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
     xml_doc_resorce = Document.new(emp_resorce_info)
     WORKER_CODE_LIST = XPath.match(xml_doc_resorce, "//worker").map{ |worker| worker.attributes["code"] }   
     #puts WORKER_CODE_LIST #codes related to various workers registered in libreplan. 
      
     employee_info=[]

    (0..(WORKER_CODE_LIST.length-1)).each do |i| 
        per_employee_Info={}
        xmlDataFile = ""
        xmlDataFile << open("http://172.16.17.18:8080/libreplan/ws/rest/resources/"+"#{WORKER_CODE_LIST[i]}", :http_basic_authentication=>["wsreader", "wsreader"]){ |f| f.read }
        
        xmldoc = Document.new(xmlDataFile)
        leaves=0
        # data = ActiveSupport::JSON.decode(myJSON)
        
        fullname = XPath.match(xmldoc, "//worker").map{|work| work.attributes["first-name"]}.join() + " " + XPath.match(xmldoc, "//worker").map{|work| work.attributes["surname"]}.join()
        puts fullname 


        #search data in the ldap array if information is there then extract other otherwise not
        # if not there then countinue ...go to start of loop...................................
        name_index= ldap_data.index(fullname) 
        if name_index.nil?
          next
        end 

        joining_date=Date.parse(ldap_data[name_index+1])
        end_date=Date.parse(ldap_data[name_index+2]) if ldap_data[name_index+2] != ""
         
          
        if !end_date.nil? && end_date < Date.parse(Time.now.strftime("%Y-%m-%d") ) 
          # if end_date is less than current date then there is no need to fetch data 
          next
        end   


        begin

            XPath.each(xmldoc, "//calendar-exception"){ |excep| 

             if excep.attributes["calendar-exception-type-code"] == "CALENDAR_EXCEPTION_TYPE0002"
               leaves = leaves+1
             end  
            }   

            #puts leaves          
        rescue Exception => e
            puts "exception has occured"
            puts e.message
        end

        #..............changing data to json format..............
        number_of_months_since_joining = (Time.now.year - joining_date.year)*12 + (Time.now.month-joining_date.month)
        no_of_holidays = 1.25 * number_of_months_since_joining
        per_employee_Info["username"]=fullname
        per_employee_Info["earned"]= no_of_holidays
        per_employee_Info["taken"]= leaves
        per_employee_Info["remaining"]=no_of_holidays - leaves
        employee_info << per_employee_Info
    end
        employees_info["employees"]=employee_info
        # puts employees_info  
        json_info=JSON.generate(employees_info)
        puts json_info
        
        session.puts json_info
        session.close
end
