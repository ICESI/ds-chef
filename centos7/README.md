# Self-provision of infrastructure

### Issues

#### vagrant up results in box with no ssh permissions while deploying

Version 1.8.5 of vagrant has an issue related with ssh keys. Workaround is to add a configuration parameter in the Vagrantfile. Also take into account that when you use a box without chef you have to provision it manually using shell inline provisioner.

solution:
```
$ vagrant init centos/7; vagrant up --provider virtualbox
$ vim Vagrantfile
config.ssh.insert_key = false
```

#### vagrant package results in box with no guest additions

solution:
```
$ vagrant up
$ vagrant ssh -c 'sudo rm -f /etc/udev/rules.d/60-vboxadd.rules'
$ vagrant package --output CentosOS-7....
```

or let vagrant to re-install guest additions for you (not recommended)

```
$ vagrant plugin install vagrant-vbguest
```

#### vagrant ssh results in permission denied

solution:
```
config.vm.provision "shell", inline: <<-SHELL
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
SHELL
```
