# Self-provision of infrastructure

## Commands

### Vagrant commands

These commands must be executed from the host machine

| Command | Description   |
|---|---|
| vagrant up | Run provision of the virtual machine |
| vagrant up --no-provision | Create the virtual machine without provisioning |
| vagrant provision | Provision the virtual machine on the fly |
| vagrant destroy | Destroy virtual machine |
| vagrant package --output box_name | Package a deployed virtual machine in a vagrant box |

### Chef commands

These commands must be run inside the virtual environment

| Command | Description   |
|---|---|
| chef-apply install_web.rb | Provision the specified recipe |

### Links

https://app.vagrantup.com/boxes/search . 
https://www.vagrantup.com/docs/provisioning/shell.html . 
https://www.vagrantup.com/docs/provisioning/chef_solo.html . 
https://docs.chef.io/resource_examples.html . 
https://docs.chef.io/kitchen.html
