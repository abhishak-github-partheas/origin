module LoadLDAP
 
  def initializeLDAP
    thing = YAML.load_file('ldap_conf.yml')
    #puts thing.inspect

    ldap = Net::LDAP.new :host => thing["host"],
     :port => thing["port"],
     :auth => {
           :method =>  thing["method"],
           :username => thing["username"],
           :password => thing["password"]
     }
     
  end

end