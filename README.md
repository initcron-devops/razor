## RAZOR server setup using ansible

Edit Vagrantfile according your requirement. If not modified, the playbook will also work.

### To create and config the infra.

Run the **vagrant up** from command line.

<pre>
	vagrant up 
</pre>

This will download the centos-6.7 box from from github and will install **ansible** and run playbook on it.

### Razor setup 

To create repo, Log in to razor server created earlier and download the ISO file of the OS.
 

E.g. 

<pre>
	vagrant ssh
	sudo su - razor
	wget http://centosmirror.go4hosting.in/centos/6.7/isos/x86_64/CentOS-6.7-x86_64-minimal.iso 
 	razor create-repo --name=centos-6.7  --iso-url file:///var/lib/razor/CentOS-6.7-x86_64-minimal.iso --task centos 
 	wget http://releases.ubuntu.com/14.04/ubuntu-14.04.3-server-amd64.iso 
 	razor create-repo --name=ubuntu-14.04 --iso-url file:///var/lib/razor/ubuntu-14.04.3-server-amd64.iso --task ubuntu/trusty
</pre>


To view the repos

<pre>
	razor repos
</pre>


To Create Broker

Execute the following command on razor server.

<pre>
	razor create-broker --name=noop --broker-type=noop
</pre>


To view broker

<pre>
	razor brokers
</pre>


To Create Tag

<pre>

	razor create-tag --name micro --rule '["<", ["num", ["fact", "memorysize_mb"]], 1000]'

	razor create-tag --name small  --rule '[">", ["num", ["fact", "memorysize_mb"]], 1000]'

</pre>

This will create two tags "small" and "micro"

To view tags

<pre>
	razor tags
</pre>

To creata a policy that will load centos  for small VMs

create a file with name **centos-small.json**" and contents 

<pre>

{
  "name": "centos-for-small",
  "repo": "centos-6.7",
  "task": "centos",
  "broker": "noop",
  "enabled": true,
  "hostname": "host${id}.initcron.com",
  "root_password": "AbhI",
  "max_count": 100,
  "tags": ["small"]
}

</pre>


and file named **ubuntu-micro.json**


<pre>
	{
  "name": "ubuntu-for-micro",
  "repo": "ubuntu-14.04",
  "task": "ubuntu/trusty",
  "broker": "noop",
  "enabled": true,
  "hostname": "host${id}.initcron.com",
  "root_password": "AbhI",
  "max_count": 100,
  "tags": ["micro"]
}
</pre>

Now execute cmd 

<pre>

	razor create-policy --json ubuntu-micro.json

	razor create-policy --json  centos-small.json

</pre>

To view polices 

<pre> 
	razor policies
</pre>


###To test the setup 


create a VM in virtual box

* Click **New**  

<img src="./screenshots/create-1.png">

* Click **Continue** and change the memnory to 1200   

<img src="./screenshots/create-2.png">


* Click **Continue**, then **Create**, then **Continue**, then **Continue**, then **Create** 

  this will create you VM 

* Now modify the VM to allow network boot   

  Click on newly created VM and the **Settings**, click on **System** and do the changes like the following

<img src="./screenshots/modify-1.png" >

* Now modify VM to get launched on the same net as razor server i.e private network 

  click on **Network** and do the changes as

<img src="./screenshots/modify-2.png">

   Click **OK**

* To start VM, click **Start**

  you will see a screen,

<img src="screenshots/startvm.png">

  click **cancel**

* Now you should see something like this.

<img src="screenshots/netboot.png"> 

  This verify that your VM is booting from Network.
  The GateWay IP in your case will will same as private network IP of razorserver in VagrantFile

* Now you will see that micro-kernel is getting loaded into VM.

<img src="screenshots/micro-kernel.png">

* Next you will this screen, that verifies that the micro-kernel is loaded.

<img src="screenshots/micro-kernel_complete.png">

* Now razor will load the new OS on your VM depending on your policy.

<img src="screenshots/newos.png">










