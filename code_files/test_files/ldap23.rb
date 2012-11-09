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


def get_conf_data(config_file)
      config_data= YAML.load(File.open(config_file))
end 

def get_Connection(config_data)
   ldap = Net::LDAP.new :host => config_data["host"],
      :port => config_data["port"],
      :auth => {
           :method =>  config_data["method"],
           :username => config_data["username"],
           :password => config_data["password"]
     }
end 

def is_authorized(ldap)  # returns true if auth works, false otherwise (or throws error if it can't connect to the server)
    if ldap.bind
      return "authentication succeeded"
    else
      return "authentication failed"
    end
end    

def search_inside_ldap(ldap,filter,treebase,attrs)
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
    return ldap_data
end

def read_data_frm_libreplan(url,auth_hash)
    emp_resorce_info = ""
    emp_resorce_info<<open(url, auth_hash){ |f| f.read }
    xml_doc_resorce = Document.new(emp_resorce_info)
    return   xml_doc_resorce 
end  

def extract_Emp_List_Libreplan(xml_doc_resorce)
    worker_id_list = XPath.match(xml_doc_resorce, "//worker").map{ |worker| worker.attributes["code"] }   
    return worker_id_list  
end

def calc_leaves_emp(xmldoc)
    leaves =0
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
    return leaves
end  

def months_since_join(joining_date)
  number_of_months_since_joining = (Time.now.year - joining_date.year)*12 + 
                                           (Time.now.month-joining_date.month)
  return number_of_months_since_joining
end 

def get_joining_date(ldap_data,fullname)
   name_index= ldap_data.index(fullname) 
   joining_date=Date.parse(ldap_data[name_index+1])
   return joining_date
end  

def per_emp_info_hash(xmldoc ,ldap_data)
  per_employee_Info={}
  per_employee_Info["username"] = get_userName(xmldoc)
  per_employee_Info["earned"] =  1.25 * months_since_join(get_joining_date(ldap_data,per_employee_Info["username"]))
  per_employee_Info["taken"] =  calc_leaves_emp(xmldoc)
  per_employee_Info["remaining"] = per_employee_Info["earned"] -  per_employee_Info["taken"]
  return per_employee_Info
end           

def get_userName(xmldoc)
   XPath.match(xmldoc, "//worker").map{|work| work.attributes["first-name"]}.join() + " " + XPath.match(xmldoc, "//worker").map{|work| work.attributes["surname"]}.join()
end

def is_User_in_Ldap?(xmldoc,ldap_data)
  fullname = get_userName(xmldoc)
  name_index= ldap_data.index(fullname) 
  if name_index.nil?
     return false
  else
     return true
  end 
end  



filter = Net::LDAP::Filter.eq("uid", "*")
treebase = "dc=partheas,dc=net"
attrs=['displayname', 'employeestartdate','employeeenddate']

config_data=get_conf_data('ldap_conf.yml')

puts config_data
 ldap=get_Connection(config_data)
puts is_authorized(ldap)
ldap_data= search_inside_ldap(ldap,filter,treebase,attrs)
p "--------ldap_data"
p ldap_data

webserver = TCPServer.new('localhost', 2005)
employees_info={}
url="http://172.16.17.18:8080/libreplan/ws/rest/resources"
auth_hash={:http_basic_authentication=>["wsreader", "wsreader"]}
while (session = webserver.accept)
  worker_id_list = extract_Emp_List_Libreplan(read_data_frm_libreplan(url,auth_hash) )
  employee_info=[]
  (0..(worker_id_list.length-1)).each do |i| 
      per_employee_Info={}
      xmlDataFile = ""
      xmlDataFile << open(url+"/"+"#{worker_id_list[i]}", auth_hash){ |f| f.read }
      xmldoc = Document.new(xmlDataFile)
      fullname=get_userName(xmldoc)
      puts fullname 
      if(!is_User_in_Ldap?(xmldoc,ldap_data))
        next  
      end 
      name_index= ldap_data.index(get_userName(xmldoc)) 
      end_date=Date.parse(ldap_data[name_index+2]) if ldap_data[name_index+2] != ""
      if !end_date.nil? && end_date < Date.parse(Time.now.strftime("%Y-%m-%d") ) 
          # if end_date is less than current date then there is no need to fetch data 
          next
      end  
      employee_info << per_emp_info_hash(xmldoc,ldap_data)
  end
  employees_info["employees"]=employee_info
  # puts employees_info  
  json_info=JSON.generate(employees_info)
  puts json_info
  session.puts json_info
  session.close
end     
