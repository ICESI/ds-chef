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

### Chef commands

These commands must be run inside the virtual environment

| Command | Description   |
|---|---|
| chef-apply install_web.rb | Provision the specified recipe |

### Issues

Version 1.8.5 of vagrant has an issue related with ssh keys. Workaround is to add a configuration parameter in the Vagrantfile. Also take into account that when you use a box without chef you have to provision it manually using shell inline provisioner.

```
vagrant init centos/7; vagrant up --provider virtualbox
vim Vagrantfile
config.ssh.insert_key = false
```
