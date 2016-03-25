$script = <<EOS
echo "Install python libs and ansible on VM"

#Install python libs and ansible
yum install python-devel -y
yum install libevent-devel -y
yum install python-pip -y
pip install ansible

#Put you ssh pub key to root and vagrant authorized_keys file
if [ ! -d /root/.ssh ]
then
	mkdir /root/.ssh
fi
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL7nij+Mi4ul8AwEMi4CDZaCkkZVPBbuCSDvCMvhx/e5Vf2tdLs8mmbOSRTnGZVkZzwYfWHygpxoVv3Y+YyU0PLqbOKOqF3E8SyGvkEc3khmA/GSQKUrtWXx30fbHTFXlhWfS1QfbOT4xKEaKAjBHNLNCRnQ8UzB0ja6wOdgMmRUC9r8CMhzzgJdaVzs7SOGeFc6+K0FF6EcJQ7VIK4HBvyzVRQTI0NqRV9GuMPYg6ohxx/LUCqvryLJWELAupEgb6Zc81kU+W1hvqkDwrEIpCJ0+BuiyIjdMKYH9zs4OzpPyvZpYhJOCivC5MhQ1dTUmzLJQ1LDYOjzjxRmjx82ut initcron@vHost5' >> /root/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL7nij+Mi4ul8AwEMi4CDZaCkkZVPBbuCSDvCMvhx/e5Vf2tdLs8mmbOSRTnGZVkZzwYfWHygpxoVv3Y+YyU0PLqbOKOqF3E8SyGvkEc3khmA/GSQKUrtWXx30fbHTFXlhWfS1QfbOT4xKEaKAjBHNLNCRnQ8UzB0ja6wOdgMmRUC9r8CMhzzgJdaVzs7SOGeFc6+K0FF6EcJQ7VIK4HBvyzVRQTI0NqRV9GuMPYg6ohxx/LUCqvryLJWELAupEgb6Zc81kU+W1hvqkDwrEIpCJ0+BuiyIjdMKYH9zs4OzpPyvZpYhJOCivC5MhQ1dTUmzLJQ1LDYOjzjxRmjx82ut initcron@vHost5' >> /home/vagrant/.ssh/authorized_keys

#Install git
yum install git -y 

#Download razor-server repo from github 
git clone https://github.com/initcron-abhijit/razor.git
cd razor-server

#Edit this to include your changes
cat > vars.yml << FILE_END
---
dhcp_range: 192.168.2.50,192.168.2.200,12h
interface: eth1
no_dhcp_interface: eth0
gateway: "{{ ansible_eth1['ipv4']['address'] }}@eth1"
FILE_END

#Run ansible playbook for razor setup
ansible-playbook razor-server.yml -e @vars.yml

EOS
 
Vagrant.configure("2") do |config|
 	config.vm.box = "centos-6.7"
	config.vm.box_url = "https://github.com/CommanderK5/packer-centos-template/releases/download/0.6.7/vagrant-centos-6.7.box"
        config.vm.define "razor_server" do |razor_server|
        razor_server.vm.network "private_network", ip: "192.168.2.3"
        razor_server.vm.hostname = "razor-server.initcron.com"
        razor_server.vm.provider "virtualbox" do |vb|
#        vb.gui = true
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "80",
          "--memory", "1024",
	]
	end
       razor_server.vm.provision "shell", inline: $script
       end
end
