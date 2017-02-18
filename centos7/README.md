# Self-provision of infrastructure

### Issues

Version 1.8.5 of vagrant has an issue related with ssh keys. Workaround is to add a configuration parameter in the Vagrantfile. Also take into account that when you use a box without chef you have to provision it manually using shell inline provisioner.

```
vagrant init centos/7; vagrant up --provider virtualbox
vim Vagrantfile
config.ssh.insert_key = false
```
