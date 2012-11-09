#require 'vagrant-ansible'
#
ip="172.16.17.18"
#vhost_root="/vagrant/src/thirdparty/prestashop/app"

Vagrant::Config.run do |config|
  config.vm.box = "holyplan"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"
  config.vm.network :hostonly, "#{ip}"
  config.vm.customize ["modifyvm", :id, "--memory", 2048]

 #config.vm.provision :ansible do |ansible|
 # ansible.playbook = [
 #  "playbooks/ubuntu-nginx.yml",
 #  "playbooks/ubuntu-nginx-php.yml",
 #  "playbooks/ubuntu-nginx-php-vhost.yml",
 #  "playbooks/ubuntu-mysql.yml",
 #  "playbooks/prestashop.yml",
 #  "playbooks/ubuntu-postfix-mailcatcher.yml",
 #  "playbooks/scrapy.yml"
 # ]
 # ansible.hosts = "webservers"
 # ansible.options = "-e ip=#{ip} -e vhost_root=#{vhost_root} -e vhost=#{ip} -e update_cache=yes"
 #end

  # Identifier, guest path, host path
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  # Guest Port, Host Port
  # config.vm.forward_port 80, 4567
end
