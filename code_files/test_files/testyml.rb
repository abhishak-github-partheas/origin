require 'yaml'
thing = YAML.load_file('ldap_conf.yml')
puts thing.inspect