bash 'install_aptly' do
  code <<-EOH
    deb http://repo.aptly.info/ squeeze main
    sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 9E3E53F19C7DE460
    apt-get update
    apt-get install aptly
  EOH
end

cookbook_file '/tmp/gnupg.tar' do
  source 'gnupg_notpassphrase.tar'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

bash 'uncompress_keys' do
  cwd "/tmp"
  code <<-EOH
    tar xvf gnupg.tar -C /root/
    chown -R root:root /root/.gnupg
  EOH
end

#bash "change ownership" do
#  cwd "/root"
#  code <<-EOH
#    chown -R root:root /root/.gnupg
#  EOH
#end

bash 'import_keys' do
  code <<-EOH
    gpg --no-default-keyring --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg --export | gpg --no-default-keyring --keyring trustedkeys.gpg --import
  EOH
  returns [0, 2]
end

bash 'create_mirror' do
  code <<-EOH
    aptly mirror create -architectures=amd64 -filter='Priority (required) | Priority (important) | Priority (standard) | python3' -filter-with-deps xenial-main-python3 http://mirror.upb.edu.co/ubuntu/ xenial main
    aptly mirror update xenial-main-python3    
  EOH
end

bash 'create_snapshot' do
  code <<-EOH
    aptly snapshot create xenial-snapshot-python3 from mirror xenial-main-python3
    aptly publish snapshot xenial-snapshot-python3
  EOH
    not_if 'aptly snapshot list | grep xenial-snapshot-python3'
end

# the package that lets you easily define new services
package "daemon"

cookbook_file '/etc/init.d/aptly-daemon' do
  source 'aptly-daemon'
  owner 'root'
  group 'root'
  mode '0700'
  action :create
end

bash "add_aptly_daemon" do
  code <<-EOH
    update-rc.d aptly-daemon defaults
  EOH
end

service "aptly-daemon" do
    supports :restart => true, :start => true, :stop => true, :reload => true
    action [:enable, :start]
end

