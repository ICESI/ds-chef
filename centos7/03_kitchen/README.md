## Tutorial kitchen

### Instalar chekdk
```
$ sudo dpkg -i chefdk_2.0.28-1_amd64.deb
```

### Adicionar una box de centos
```
$ vagrant box add centos-7.1706_v0.2.0 centos-7.1706_v0.2.0.box
```

### Crear un cookbook
```
$ mkdir cookbooks
$ chef generate cookbook cookbooks/git_cookbook
```

### Adicionar receta

```
$ vi cookbooks/git_cookbook/recipes/default.rb
```

```
#
# Cookbook:: git_cookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

package "git"
```

### Crear archivo .kitchen.yml
```
$ vi .kitchen.yml
```

```
driver:
  name: vagrant
  customize:
    memory: 1024
    cpus: 2

provisioner:
  name: chef_zero
  product_name: chef
  product_version: 13.2.20

platforms:
- name: centos-7
  driver:
    box: centos-7.1706

verifier:
  name: inspec

suites:
  - name: default
    run_list:
      - recipe[git_cookbook::default]
    verifier:
      inspec_tests:
        - path: cookbooks/git_cookbook/test/smoke/default
    attributes:
```

### Listar instancias
```
$ kitchen list
Instance          Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-centos-7  Vagrant  ChefZero     Busser    Ssh        <Not Created>  <None>
```
### Crear máquina virtual sin aprovisionar
```
$ kitchen create default-centos-7
```

### Listar instancias
```
$ kitchen list
Instance          Driver   Provisioner  Verifier  Transport  Last Action  Last Error
default-centos-7  Vagrant  ChefZero     Busser    Ssh        Created      <None>
```

### Crear máquina virtual y aprovisionar
```
$ kitchen converge default-centos-7
```

### Adicionar pruebas unitarias
```
$ vi cookbooks/git_cookbook/test/smoke/default/default_test.rb
```

```
# # encoding: utf-8

# Inspec test for recipe git_cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe user('root') do
    it { should exist }
  end
end

describe port(22) do
  it { should_not be_listening }
end

describe package('git') do
  it { should be_installed }
end

describe package('httpd') do
  it { should_not be_installed }
end
```

### Ejecutar las pruebas
```
$ kitchen verify default-centos-7
```

### Ejecutar desde create hasta destroy en un solo comando (CI)
```
$ kitchen test
```

### Referencias
https://docs.chef.io/kitchen.html  
http://kitchen.ci/docs/getting-started/adding-platform  
https://github.com/test-kitchen/kitchen-vagrant/blob/master/README.md  
https://matschaffer.github.io/knife-solo/
