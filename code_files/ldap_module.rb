module Ldap
 
  def get_connection(config_data)
    ldap = Net::LDAP.new :host => config_data['LdapHost'],
    :port => config_data["LdapPort"],
    :auth => {
              :method => config_data['method'],
              :username => config_data['username'],
              :password => config_data['password']
             }
  end 
  
  def is_authorized(ldap)  
    if ldap.bind
      return true
    else
      return false
    end
  end    
  
  def search_inside_ldap(ldap,filter,treebase,attrs)
    ldap_data = []
    ldap.search(:base => treebase, :attributes => attrs, :filter => filter) do |entry|
      entry.each do |attribute, values|
        if attribute.to_s == 'displayname' 
          ldap_data << values.join('')
        end 
        if attribute.to_s == 'employeestartdate'   
          ldap_data << values.join('')
        end 
        if attribute.to_s == 'employeeenddate'   
          ldap_data << values.join('')
        end
      end
      
      if ldap_data.length % 3 != 0
        ldap_data << ''
      end
    end
    return ldap_data
  end
end