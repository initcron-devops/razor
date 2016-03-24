Vagrant.configure("2") do |config|
 	config.vm.box = "puppet-template"
        config.vm.define "razor_master_v2" do |razor_master_v2|
        razor_master_v2.vm.network "private_network", ip: '192.168.2.8'
        razor_master_v2.vm.hostname = "razor-master-2.test"
        razor_master_v2.vm.provider "virtualbox" do |vb|
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "80",
          "--memory", "1024",
	]
	end
	razor_master_v2.vm.provision "shell", path: "./boot-strap-vagrant.sh"
        end
end
