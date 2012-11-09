require 'net/ldap'
require "socket"
require 'rexml/document'
require 'open-uri'
require "crack"
require "json"
require 'rubygems'
require "active_support"

include REXML



ldap = Net::LDAP.new :host => 'ipa.partheas.net',
     :port => 389,
     :auth => {
           :method =>  :anonymous,
           :username => "cn=users,cn=accounts,dc=partheas,dc=net",
           :password => ""
     }
     
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

#p ldap.get_operation_result


webserver = TCPServer.new('localhost', 2004)
#base_dir = Dir.new(".")
WORKER_CODE_LIST = []
while (session = webserver.accept)
    session.print("HTTP/1.1 200/OK\r\nContent-type:text/html\r\n\r\n")
    session.print("<!Doctype html> <html> <head> <title> Holidays Info </title>
     <style> 
    
        span {
            color: green
        }

        table {
              font-family: verdana,arial,sans-serif;
              font-size:15px;
              color:#333333;
              border-color: #666666;
              border-collapse: collapse;
               -moz-border-radius: 6px 0 0 0;
                    -webkit-border-radius: 6px 0 0 0;
                     border-radius: 6px 0 0 0;
             }
        table th {
            padding: 8px;
            border-style: solid;
            border-color: #666f66;
            background-color: #dedede;
             -moz-border-radius: 6px 0 0 0;
                  -webkit-border-radius: 6px 0 0 0;
                   border-radius: 6px 0 0 0;
            }
        table td {
            padding: 8px;
            border-style: solid;
            border-color: #666666;
            background-color: #ffffff;
             -moz-border-radius: 6px 0 0 0;
                  -webkit-border-radius: 6px 0 0 0;
                   border-radius: 6px 0 0 0;
            }

     </style> </head><body>")

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

     i=0
     data["resource_list"]["worker"].each{ |worker|
       WORKER_CODE_LIST[i] = worker["code"]
       i+=1
     }
    
    session.print("<h1 style='align:center'> Holidays Info Of <span>Partheas</span> Employees </h1>")
    session.print("<table>
                        <tr>
                            <td><b>Emplayee Name</td>
                            <td><b>Holidays Earned</td>
                            <td><b>Holidays Taken</td>
                            <td><b>Remaining Holidays</td>
                        </tr>

                    ")
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
         
         fullname = data["worker"]["first_name"] + " " + data["worker"]["surname"]
#         puts fullName

         #search data in the ldap array if information is there then extract other otherwise not
         # if not there then countinue ...go to start of loop
         name_index= ldap_data.index(fullname) 
         puts name_index
         if name_index.nil?
          next
         end

         joining_date=Date.parse(ldap_data[name_index+1])
         end_date=Date.parse(ldap_data[name_index+2]) if ldap_data[name_index+2] != ""
         
          
         if !end_date.nil? && end_date < Date.parse(Time.now.strftime("%Y-%m-%d") )
           # no need to fetch data 
           next
         end    

         session.print("<tr>")
         session.print ("<td><font color='red'>"  + data["worker"]["first_name"] + " </font></td>")  
         begin
             data["worker"]["calendar"]["calendar_exception_list"]["calendar_exception"].each { |entry|
                      if entry.length == 2 
                          entry = Hash[*entry.flatten]
                          puts "Entered!!!!!!!!!!!!!!!!!"
                      end    
            
                      puts entry["calendar_exception_type_code"]
                      puts ".................."
                      if entry["calendar_exception_type_code"].eql? "CALENDAR_EXCEPTION_TYPE0002"
                         #session.print "Type:'Leave' at Date:" + entry["date"] + "<br/>"
                         leaves = leaves+1
                           puts leaves
                      end
                      }
             rescue Exception => e
               puts "exception has occured"
               puts e.message
         end
          number_of_months_since_joining = (Time.now.year - joining_date.year)*12 + (Time.now.month-joining_date.month)
          no_of_holidays = 1.25 * number_of_months_since_joining
          session.print  "<td>#{no_of_holidays}</td>"
          session.print "<td>#{leaves}</td>"
          session.print "<td>#{no_of_holidays - leaves}</td></tr>"
                 end
    session.print("</table>") 
  session.close

end