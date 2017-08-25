template '/etc/haproxy/haproxy.cfg' do
	source 'haproxy.erb'
	mode 0644
	owner 'root'
	group 'wheel'
	variables(
		:web_servers => node[:web_servers]
	)
end

service 'haproxy' do
  action [ :start, :enable ]
end
