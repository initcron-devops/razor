#!/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
#vagrant box add --name centos-6.7 https://github.com/CommanderK5/packer-centos-template/releases/download/0.6.7/vagrant-centos-6.7.box
vagrant up razor_master_v2
IP=$(grep 'private_network'  Vagrantfile | awk -F"'" '{print $2}')
sed "s/IP/${IP}/g" test_hosts > hosts
ansible-playbook -i hosts razor-server.yml -e @vars.yml
