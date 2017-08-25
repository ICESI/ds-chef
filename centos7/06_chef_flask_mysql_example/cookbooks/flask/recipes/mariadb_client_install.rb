cookbook_file '/etc/yum.repos.d/MariaDB.repo' do
	source 'MariaDB.repo'
	mode 0644
	owner 'root'
	group 'wheel'
end

#sudo yum install MariaDB-client

yum_package 'MariaDB-server'
