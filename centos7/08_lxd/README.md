### Using Vagrant wit LXC/LXD containers

#### Install
Install and configure LXD
```
# install lxd
sudo apt install -y lxd
sudo apt install zfsutils-linux -y 
# Configure init options
lxd init
# Answer all default options to yes except the following one in order to let the containers to receive an IP from the LAN
Would you like LXD to be available over the network? (yes/no) [default=no]: yes
# install vagrant
wget -c https://releases.hashicorp.com/vagrant/2.0.3/vagrant_2.0.3_x86_64.deb
sudo dpkg -i vagrant_2.0.3_x86_64.deb
# install lxd plugin
vagrant plugin install vagrant-lxd
# enable https api access
sudo lxd init --auto --network-address=127.0.0.1 --network-port=8443
# set up a network bridge (press enter to accept the default values)
sudo dpkg-reconfigure -p medium lxd
# add your user to the lxd group
sudo usermod -a lxd -G $(whoami)
# apply new group membership
newgrp lxd
# Provide a client certificate for the lxd connection
lxc config trust add ~/.config/lxc/client.crt
# run test
vagrant init --minimal debian/stretch64
vagrant up --provider lxd
lxc list
lxc exec my_vagrant_container /bin/bash
exit
vagrant destroy -f
```

How to create a new network profile 
```
lxc profile list
lxc profile create bridgeprofile
cat <<EOF | lxc profile edit bridgeprofile
description: Bridged networking LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
EOF
lxc profile show bridgeprofile
lxc profile list
lxc launch -p default -p bridgeprofile ubuntu:x bridge_test
lxc list
lxc delete bridge_test
# In case you need to delete the created profile
lxc profile delete bridgeprofile
```

```
# Let’s make an existing container to use the new profile, “default,bridgeprofile”.
vagrant up --provider lxd
lxc list
lxc profile assign my_vagrant_container default,bridgeprofile
# Now we just need to restart the networking in the container.
lxc exec my_vagrant_container -- systemctl restart networking.service
# Verify that the container now has an IP address
lxc list
# ssh to the container
vagrant ssh
exit
vagrant destroy -f
```

Use the new profile from scratch at vagrant up
```
vi Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"

  config.vm.provider 'lxd' do |lxd|
    lxd.profiles = ['default', 'bridgeprofile']
  end
end
vagrant up --provider lxd
# Verify that the container now has an IP address
lxc list
# ssh to the container
vagrant ssh
exit
vagrant destroy -f
```

Modify the Vagrantfile in the following way for multiple deployments
```
vi Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "debian/stretch64"
  config.vm.provider 'lxd' do |lxd|
    lxd.profiles = ['default', 'bridgeprofile']
  end
  config.vm.define :k8smaster do |master|
  end
  config.vm.define :k8sworker do |worker|
  end
end
vagrant up --provider lxd
# Verify that the containers now have an IP address
lxc list
# ssh to the one of the containers
vagrant sshk8smaster
exit
vagrant destroy -f
```

In order to share folders you must run the following commands
```
echo root:$(id -u):1 | sudo tee -a /etc/subuid
echo root:$(id -g):1 | sudo tee -a /etc/subgid
```

You can push or pull files into/from a container using the following command:
```
lxc file push some_file.tar.gz lxc_container_name/tmp/
lxc file pull lxc_container_name/tmp/some_file.tar.gz .
```

### Docker on LXD

```
lxc launch -p default -p bridgeprofile ubuntu:18.04 my_lxd_container -c security.nesting=true
lxc exec my_lxd_container -- apt update
lxc exec my_lxd_container -- apt dist-upgrade -y
lxc exec my_lxd_container -- apt install docker.io -y
lxc exec my_lxd_container -- docker run --detach --name app carinamarina/hello-world-app
# Look how my_lxd_container has two ethernet interfaces (eth0, docker0)
lxc list
```

### Kubernetes on LXD
```
sudo snap install conjure-up --classic
conjure-up kubernetes
kubectl cluster-info
kubectl proxy
# http://localhost:8001/ui
juju gui
juju add-unit kubernetes-worker -n 2
```

**Note**: Research about how to make work docker with vagrant+lxd

#### References
https://app.vagrantup.com/boxes/search  
https://blog.ubuntu.com/2016/03/16/lxd-2-0-installing-and-configuring-lxd-212  
https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/  
https://stgraber.org/2016/04/13/lxd-2-0-docker-in-lxd-712/  
https://itnext.io/tutorial-part-1-kubernetes-up-and-running-on-lxc-lxd-b760c79cd53f  
https://itnext.io/tutorial-part-2-kubernetes-up-and-running-on-lxc-lxd-6d60e98f22df  
https://www.adictosaltrabajo.com/tutoriales/instalar-kubernetes-on-premise-sin-dolor/

#### Troubleshooting
Client certificate do not exist
```
# configure lxd to be able to access network through unix socket
lxc config set core.https_address [::]
lxc config set core.trust_password some-secret-password
lxc remote add host-a 10.3.142.1 <- I'm not sure about this IP
```

