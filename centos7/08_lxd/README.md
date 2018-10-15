### Work in Progress

#### Install

Install and configure LXD
```
# install lxd
sudo apt install -y lxd
sudo apt install zfsutils-linux -y 
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
```

How to create a network profile and assign IPs from LAN
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
lxc profile delete profile_name_to_delete
lxc launch -p default -p bridgeprofile ubuntu:x mybridge
lxc list
```

```
# Let’s assign mycontainer to use the new profile, “default,bridgeprofile”.
lxc list
lxc profile assign my_vagrant_container default,bridgeprofile
# Now we just need to restart the networking in the container.
lxc exec my_vagrant_container -- systemctl restart networking.service
# Verify that the container now has an IP address
lxc list
# ssh to the container
vagrant ssh
```

**Note**: Find a way to do this straight from vagrant up

#### References
https://app.vagrantup.com/boxes/search  
https://blog.ubuntu.com/2016/03/16/lxd-2-0-installing-and-configuring-lxd-212  
https://blog.simos.info/how-to-make-your-lxd-containers-get-ip-addresses-from-your-lan-using-a-bridge/

#### Troubleshooting
Client certificate do not exist
```
# configure lxd to be able to access network through unix socket
lxc config set core.https_address [::]
lxc config set core.trust_password some-secret-password
lxc remote add host-a 10.3.142.1 <- I'm not sure about this IP
```
