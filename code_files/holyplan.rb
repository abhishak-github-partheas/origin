require 'net/ldap'
require 'socket'
require 'rexml/document'
require 'open-uri'
require 'crack'
require 'json'
require 'active_support'
require 'yaml'
require 'json'
include REXML
require_relative 'ldap_module.rb'
include  Ldap
require_relative 'libreplan_module.rb'
include Libreplan
require_relative 'parsing_classes.rb'

if ARGV.length != 1
  print "error : please give path of configuration file \n"
end
config_path = ARGV[0]  
begin
  file = File.open(config_path)
  if file
     puts "File opened successfully\n"
  end
rescue  Exception => e 
   puts "exception:" + e.message 
end
config_data = YAML.load(file)

filter = Net::LDAP::Filter.eq('uid', '*')
treebase = config_data['treebase'] 
attrs = config_data['attrs']
ldap = Ldap.get_connection(config_data)

if Ldap.is_authorized(ldap)
  puts 'authentication succeeded'
else
  puts 'authentication failed'  
end  

ldap_data = Ldap.search_inside_ldap(ldap, filter, treebase, attrs)
p ldap_data
webserver = TCPServer.new(config_data['DaemonHost'], config_data['DaemonPort'])
employees_info = {}
url = config_data['url']
auth_hash = {:http_basic_authentication => ["wsreader", "wsreader"]}

while (session = webserver.accept)
  worker_id_list = Libreplan.extract_emp_list(url, auth_hash )
  employee_info = []
  (0..(worker_id_list.length-1)).each do |i| 
    per_employee_Info = {}
    xmlDataFile = ''
    xmlDataFile << open(url+'/'+"#{worker_id_list[i]}", auth_hash){ |f| f.read }
    xmldoc = Document.new(xmlDataFile)       
    xmlparser = ParsingXml.new(xmldoc)
    fullname = xmlparser.get_username()
    puts fullname 
    ldapparser = ParsingLdapInfo.new(ldap_data,fullname)
    if(!ldapparser.is_in_ldap?())
      next  
    end
    end_date = ldapparser.get_end_date() 
    if !end_date.nil? && end_date < Date.parse(Time.now.strftime("%Y-%m-%d")) 
      next   
    end 
    employee = EmployeeInfo.new(xmlparser, ldapparser, fullname)
    employee_info << employee.to_hash
  end
  employees_info['employees'] = employee_info
  data = JsonConversion.new
  json_info = data.to_json(employees_info)
  puts json_info
  session.puts json_info
  session.close
end     
