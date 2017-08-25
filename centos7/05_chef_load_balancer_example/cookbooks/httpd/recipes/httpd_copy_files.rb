template '/var/www/html/index.html' do
	source 'index.erb'
	mode 0644
	owner 'root'
	group 'wheel'
	variables(
		:service_name => node[:service_name]
	)
end
