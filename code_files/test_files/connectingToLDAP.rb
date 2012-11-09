require 'rubygems'
require 'net/ldap'

class PartheasEmployee
  attr_accessor :name, :joiningDate, :endDate

  def initialize()
    @name  = 0
    @joiningDate = 0
    @endDate = 0
  end 

end

ldap = Net::LDAP.new :host => 'ipa.partheas.net',
     :port => 389,
     :auth => {
           :method =>  :anonymous,
           :username => "cn=users,cn=accounts,dc=partheas,dc=net",
           :password => ""
     }
     # if ldap.bind
     #   # authentication succeeded
     # else
     #   # authentication failed
     # end

# EMPLOYEE_NAMES = [], JOINING_DATES = [], END_DATES =[]
  employees = (1..10).collect{PartheasEmployee.new}

filter = Net::LDAP::Filter.eq("uid", "*.*")
treebase = "cn=users, cn=accounts, dc=partheas, dc=net"
attrs = ["displayname", "employeestartdate","employeeenddate"]

ldap.search(:base => treebase, :filter => filter, :attributes => attrs, :return_result => false) do |entry|
  #puts "DN: #{entry.dn}"
    entry.each do |attr, values|   
    	  puts "         #{attr}:"

        values.each {|value|
             puts "      --->#{value}"     
             if attr.to_s == "displayname" 
               EMPLOYEE_NAMES<<value
             end 
   
             if attr.to_s == "employeestartdate"
               JOINING_DATES.push(value)
             end

             if attr.to_s == "employeeenddate" 
               END_DATES.push(value)
             end
        }
    end
end

puts EMPLOYEE_NAMES
puts JOINING_DATES.inspect
puts END_DATES.inspect