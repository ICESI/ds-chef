puts "Ejemplos de uso de los recursos cookbook_file y template"

cookbook_file '/var/www/html/index.html' do
	source 'index.html'
	mode 0644
	owner 'root'
	group 'wheel'
end

puts node[:name]

template '/var/www/html/welcome.html' do
	source 'welcome.erb'
	mode 0644
	owner 'root'
	group 'wheel'
	variables(
		:name => node[:name]
	)
end

puts node[:courses]

template '/var/www/html/courses.html' do
	source 'courses.erb'
	mode 0644
	owner 'root'
	group 'wheel'
	variables(
		:courses => node[:courses]
	)
end
