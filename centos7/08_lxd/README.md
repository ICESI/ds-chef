### Work in Progress

#### Install

```
# install lxd
sudo apt install -y lxd
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
# create and add a client certificate
lxc config trust add /home/ubuntu/.config/lxc/client.crt
# run test
vagrant init --minimal debian/stretch64
vagrant up --provider lxd
```

#### References
https://app.vagrantup.com/boxes/search

#### Troubleshooting
```
find ~/ -iname client.crt
```
