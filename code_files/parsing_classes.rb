class ParsingXml
  @xmldoc

  def initialize(xmldoc)  
    @xmldoc = xmldoc  
  end 

  def calc_leaves_emp()
    leaves = 0
    begin
      XPath.each(@xmldoc, '//calendar-exception'){ |excep| 
        if excep.attributes['calendar-exception-type-code'] == 'CALENDAR_EXCEPTION_TYPE0002'
          leaves = leaves+1
        end  
      }   
    rescue Exception => e
      puts e.message
    end
    return leaves
  end 

  def get_username()
     XPath.match(@xmldoc, '//worker').map{|work| work.attributes['first-name']}.join() + ' ' + XPath.match(@xmldoc, '//worker').map{|work| work.attributes['surname']}.join()
  end 

end

class ParsingLdapInfo
  @ldap_data 
  @fullname

  def initialize(ldap_data ,fullname)  
    @ldap_data = ldap_data 
    @fullname = fullname
  end 

  def get_joining_date()
    name_index = @ldap_data.index(@fullname) 
    joining_date = Date.parse(@ldap_data[name_index + 1])
    return joining_date
  end  

  def get_end_date() 
    name_index = @ldap_data.index(@fullname) 
    end_date = Date.parse(@ldap_data[name_index + 2]) if @ldap_data[name_index + 2] != ''
    return end_date
  end
  
  def is_in_ldap?()
    name_index = @ldap_data.index(@fullname) 
    if name_index.nil?
      return false
    else
      return true
    end 
  end 

end  

class EmployeeInfo
  
  def initialize(xmlparser, ldapparser,fullname)
    @xmlparser = xmlparser
    @ldapparser = ldapparser 
    @fullname = fullname
  end
  
  def months_since_joining(joining_date)
    number_of_months_since_joining = (Time.now.year - joining_date.year) * 12 + (Time.now.month - joining_date.month)
    return number_of_months_since_joining
  end

  def to_hash()
    per_employee_Info = {}
    per_employee_Info['username'] = @fullname
    joining_date = @ldapparser.get_joining_date()
    per_employee_Info['earned'] = 1.25 * months_since_joining(joining_date)
    per_employee_Info['taken'] = @xmlparser.calc_leaves_emp()
    per_employee_Info['remaining'] = per_employee_Info['earned'] -  per_employee_Info['taken']
    return per_employee_Info
  end  

end

class JsonConversion

  def to_json(employees_info) 
    json_info = JSON.generate(employees_info)
  end

end